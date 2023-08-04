import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:request_api_helper/helper.dart';
import 'dart:async';
import '../request.dart';
import '../request_api_helper.dart';

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

Future<Response> requestfile(RequestApiHelperData config, {Function(int uploaded, int total)? onProgress}) async {
  final httpClients = getHttpClient();
  Uri _http = Uri.parse(config.baseUrl!);
  final response = await httpClients.postUrl(_http);
  int byteCount = 0;
  var request = MultipartRequest("POST", _http);
  Map<String, String> body = {};

  if (config.body is Map) {
    body = MapBuilder.build(config.body);
    request.fields.addAll(body);
  }

  for (int counterfile = 0; counterfile < (config.file?.path ?? []).length; counterfile++) {
    if (config.file!.path[counterfile] == '' || config.file!.path[counterfile] == 'null') {
      request.fields[config.file!.requestName[counterfile]] = 'null';
    } else {
      request.files.add(await MultipartFile.fromPath(config.file!.requestName[counterfile], config.file!.path[counterfile], contentType: MediaType('application', config.file!.path[counterfile].split('.').last)));
    }
  }

  Stream<List<int>>? streamUpload;
  request.headers.addAll(config.header!);
  if (onProgress != null) {
    var msStream = request.finalize();
    var totalByteLength = request.contentLength;
    if (config.debug ?? false) {}
    String decodes = request.headers[HttpHeaders.contentTypeHeader] ?? '';
    config.header?.forEach((key, value) {
      if (response.headers.value(key) == null) {
        response.headers.add(key, value);
      }
    });
    response.headers.set(HttpHeaders.contentTypeHeader, {decodes});

    getSize('Header ', response.headers.toString(), debug: config.debug ?? false);
    streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;
          onProgress(byteCount, totalByteLength);
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
    request.headers['content-type'] = 'multipart/form-data';
    final getResponse = await request.send();
    return Response(await getResponse.stream.bytesToString(), getResponse.statusCode);
  }
}

class DownloadAdd {
  int id = 0;
  RequestApiHelperDownloadData data;
  String? url;
  Api type;
  RequestApiHelperDownloadData? download;
  Function(int uploaded, int total)? onProgress;
  DownloadAdd(this.data, {this.download, this.onProgress, required this.type, this.url}) {
    id = DateTime.now().millisecondsSinceEpoch;
  }
}

class DownloadDone {
  int id;
  DownloadDone(this.id);
}

class DownloadQueue {
  int id = 0;
  RequestApiHelperDownloadData data;
  String? url;
  Api type;
  RequestApiHelperDownloadData? download;
  Function(int uploaded, int total)? onProgress;
  DownloadQueue(this.data, {this.download, this.onProgress, required this.type, this.url}) {
    id = DateTime.now().millisecondsSinceEpoch;
  }
}

class MapBuilder {
  // {"sparepart" :[
  //    {
  //      "nama" : "a",
  //      "kelas" : "b",
  //    },
  //   ],
  //
  // }
  static Map<String, String> buildStringisList(String? key, value, {lastKey}) {
    Map<String, String> d = {};
    if (lastKey != null) {
      for (int i = 0; i < value.length; i++) {
        if (value[i] is Map) {
          d.addAll(buildStringisMap(value[i], lastKey: "$lastKey[$i]"));
        } else {
          d.addAll({"$lastKey[$i]": value[i].toString()});
        }
      }
    } else {
      for (int i = 0; i < value.length; i++) {
        if (value[i] is Map) {
          d.addAll(buildStringisMap(value[i], lastKey: "$key[$i]"));
        } else {
          d.addAll({"$key[$i]": value[i].toString()});
        }
      }
    }

    return d;
  }

  static Map<String, String> buildStringisMap(data, {lastKey}) {
    Map<String, String> d = {};
    if (lastKey != null) {
      data.forEach((key, value) {
        if (value is List) {
          // d.addAll(buildStringisList(key, value));
          if (value != '') {
            d.addAll(buildStringisList(key, value, lastKey: '$lastKey[$key]'));
          }
        } else if (value is Map) {
          if (value != '') {
            d.addAll(buildStringisMap(value, lastKey: '$lastKey[$key]'));
          }
        } else {
          if (value != '') {
            d.addAll({'$lastKey[$key]': value.toString()});
          }
        }
      });
    } else {
      data.forEach((key, value) {
        if (value is List) {
          if (value != '') {
            d.addAll(buildStringisList(key, value));
          }
        } else if (value is Map) {
          if (value != '') {
            d.addAll(buildStringisMap(value, lastKey: "$key"));
          }
        } else {
          if (value != '') {
            d.addAll({'$key': value.toString()});
          }
        }
      });
    }

    return d;
  }

  static build(data) {
    Map<String, String> builder = {};
    if (data is Map) {
      builder.addAll(buildStringisMap(data));
    }
    return builder;
  }

  static show(data) {
    data.forEach((k, v) {
      print('$k : $v');
    });
  }
}
