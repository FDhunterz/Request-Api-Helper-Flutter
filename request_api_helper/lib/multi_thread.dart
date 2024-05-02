import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:sql_query/random.dart';

import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/loding.dart';
import 'package:http/http.dart';

import 'helper/log.dart';
import 'helper/map_builder.dart';
import 'model/request_file.dart';

enum Api { post, get, put, delete, download }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class APIMultiThread {
  ENVData? _config;
  static final state = APIMultiThread._send();

  APIMultiThread._send();

  APIMultiThread();

  APIMultiThread config(ENVData config) {
    _config = config;
    return this;
  }

  Future<Response?> run(Api type) async {
    if (_config == null) return null;
    return await _createIsolate(_config!, type);
  }

  static Future<Response?> _createIsolate(ENVData data, Api type) async {
    final gMap = Loading.stack
        .where((element) => element.id == data.replacementId);
        print(data.replacementId);
    if(gMap.isNotEmpty){
      gMap.map((e) {
        e.stream.cancel();
      }).toList();
    }
    Response? dataProcess;

    final spawn = _apiHelperMultiRequest([
      ENVData(
        baseUrl: data.baseUrl,
        debug: data.debug,
        globalData: data.globalData,
        ignoreBadCertificate: data.ignoreBadCertificate,
        isLoading: data.isLoading,
        timeoutDuration: data.timeoutDuration,
        replacementId: data.replacementId,
      ),type]); 
      final subcription = spawn.asStream().listen((event) {
        dataProcess = event;
       });
      Loading.stack.add(Streams(
        id: data.replacementId ?? getRandomString(10),
        stream: subcription,
        isLoading: data.isLoading,
        processOnlyThisPage: data.processOnlyThisPage,
      ),);



      
      await spawn;
      subcription.cancel();
      Loading.stack.removeWhere((element) => element.id == data.replacementId);
      return dataProcess;
  }

  static Future<Response?> _apiHelperMultiRequest(List message) async {
    // ReceivePort mikeReceivePort = ReceivePort();

    // mySendPort.send(mikeReceivePort.sendPort);

      String? url;
        final config = message[0] as ENVData;
        final type = message[1] as Api;
        url = config.getUrl();

        if (config.ignoreBadCertificate) {
          HttpOverrides.global = MyHttpOverrides();
        }
        Response? req;
        if (url != null) {
          switch (type) {
            case Api.get:
              req = await get(Uri.parse(url + config.globalData!.getParams()),
                  headers: config.globalData?.header);
              break;
            case Api.put:
              final body = config.globalData?.body?.isNotEmpty ?? false
                  ? await config.convertUTF8()
                  : config.globalData?.body;
              req = await put(Uri.parse(url),
                  body: body, headers: config.globalData?.header);
              break;
            case Api.post:
              if (config.globalData?.file?.isNotEmpty ?? false) {
                var request = MultipartRequest("POST", Uri.parse(url));
                int byteCount = 0;
                Map<String, String> body = {};
                if (config.globalData?.body is Map) {
                  body = MapBuilder.build(config.globalData!.body);
                  request.fields.addAll(body);
                }

                config.globalData?.parseFile(request);
                Stream<List<int>>? streamUpload;

                if (config.globalData?.header != null)
                  request.headers.addAll(config.globalData!.header!);
                if (config.onProgress != null) {
                  final httpClients = getHttpClient();
                  final response = await httpClients.postUrl(Uri.parse(url));
                  var msStream = request.finalize();
                  var totalByteLength = request.contentLength;
                  if (config.debug ?? false) {}
                  String decodes =
                      request.headers[HttpHeaders.contentTypeHeader] ?? '';
                  config.globalData?.header?.forEach((key, value) {
                    if (response.headers.value(key) == null) {
                      response.headers.add(key, value);
                    }
                  });
                  response.headers
                      .set(HttpHeaders.contentTypeHeader, {decodes});

                  getSize('Header ', response.headers.toString(),
                      debug: config.debug ?? false);
                  streamUpload = msStream.transform(
                    StreamTransformer.fromHandlers(
                      handleData: (data, sink) {
                        sink.add(data);

                        byteCount += data.length;
                        config.onProgress!(byteCount, totalByteLength);
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

                  req = Response(getResponse, res.statusCode);
                } else {
                  request.headers['content-type'] = 'multipart/form-data';
                  final getResponse = await request.send();
                  req = Response(await getResponse.stream.bytesToString(),
                      getResponse.statusCode);
                }
              } else {
                final body = config.globalData?.body?.isNotEmpty ?? false
                    ? await config.convertUTF8()
                    : config.globalData?.body;
                req = await post(Uri.parse(url),
                    body: body, headers: config.globalData?.header);
              }
              break;
            case Api.delete:
              final body = config.globalData?.body?.isNotEmpty ?? false
                  ? await config.convertUTF8()
                  : config.globalData?.body;
              req = await delete(Uri.parse(url),
                  body: body, headers: config.globalData?.header);
              break;
            default:
          }
        }
        return req;
  }
}

HttpClient getHttpClient({Duration? duration}) {
  HttpClient httpClient = HttpClient()
    ..connectionTimeout = duration ?? const Duration(seconds: 120)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  return httpClient;
}
