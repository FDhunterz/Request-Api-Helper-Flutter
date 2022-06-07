import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import '../request.dart';

HttpClient getHttpClient({Duration? duration}) {
  HttpClient httpClient = HttpClient()
    ..connectionTimeout = duration ?? const Duration(seconds: 120)
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

  return httpClient;
}

Future<String> readResponseAsString(HttpClientResponse response) {
  var completer = Completer<String>();
  var contents = StringBuffer();
  response.transform(utf8.decoder).listen((String data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

Future<Response> requestfile(RequestApiHelperData config, {Function(int uploaded, int total)? onUploadProgress}) async {
  final httpClients = getHttpClient();
  Uri _http = Uri.parse(config.baseUrl!);
  final response = await httpClients.postUrl(_http);
  int byteCount = 0;
  var request = MultipartRequest("POST", _http);

  if (config.body is Map) {
    config.body!.forEach((k, v) {
      request.fields[k] = v;
    });
  }

  for (int counterfile = 0; counterfile < config.file!.path.length; counterfile++) {
    if (config.file!.path[counterfile] == '' || config.file!.path[counterfile] == 'null') {
      request.fields[config.file!.requestName[counterfile]] = 'null';
    } else {
      request.files.add(await MultipartFile.fromPath(config.file!.requestName[counterfile], config.file!.path[counterfile], contentType: MediaType('application', config.file!.path[counterfile].split('.').last)));
    }
  }

  Stream<List<int>>? streamUpload;
  request.headers.addAll(config.header!);
  if (onUploadProgress != null) {
    var msStream = request.finalize();
    var totalByteLength = request.contentLength;
    String decodes = request.headers[HttpHeaders.contentTypeHeader] ?? '';
    response.headers.add(HttpHeaders.authorizationHeader, {request.headers[HttpHeaders.authorizationHeader]});
    response.headers.set(HttpHeaders.contentTypeHeader, {decodes});

    streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;
          onUploadProgress(byteCount, totalByteLength);
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    await response.addStream(streamUpload);
    final res = await response.close();
    final getResponse = await readResponseAsString(res);

    return Response(getResponse, res.statusCode);
  } else {
    final getResponse = await request.send();
    return Response(await getResponse.stream.bytesToString(), getResponse.statusCode);
  }
}