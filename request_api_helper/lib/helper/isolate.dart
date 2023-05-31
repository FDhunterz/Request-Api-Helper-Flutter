import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart';
import 'package:request_api_helper/request_api_helper.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class RequestIsolate {
  Uri url;
  Map<String, String>? headers;
  Object? body;
  Api type;
  bool openAllSecurity;
  RequestIsolate({this.headers, required this.url, required this.type, this.body, this.openAllSecurity = false});

  static Future<Response> getRequest(RequestIsolate data) async {
    return await _createIsolate(data);
  }

  static Future<Response> _createIsolate(RequestIsolate data) async {
    ReceivePort myReceivePort = ReceivePort();

    final spawn = await Isolate.spawn<SendPort>(_sReq, myReceivePort.sendPort);

    SendPort mikeSendPort = await myReceivePort.first;

    ReceivePort mikeResponseReceivePort = ReceivePort();

    mikeSendPort.send([data, mikeResponseReceivePort.sendPort]);

    final mikeResponse = await mikeResponseReceivePort.first;
    spawn.kill();
    return mikeResponse;
  }

  static void _sReq(SendPort mySendPort) async {
    ReceivePort mikeReceivePort = ReceivePort();

    mySendPort.send(mikeReceivePort.sendPort);

    await for (var message in mikeReceivePort) {
      if (message is List) {
        final url = message[0].url;
        final header = message[0].headers;
        final body = message[0].body;
        final type = message[0].type;
        final openAllSecurity = message[0].openAllSecurity;

        final SendPort mikeResponseSendPort = message[1];
        if (openAllSecurity) {
          HttpOverrides.global = MyHttpOverrides();
        }
        Response? req;
        switch (type) {
          case Api.get:
            req = await get(url, headers: header);
            break;
          case Api.put:
            req = await put(url, body: body, headers: header);
            break;
          case Api.post:
            req = await post(url, body: body, headers: header);
            break;
          case Api.delete:
            req = await delete(url, body: body, headers: header);
            break;
          default:
        }
        mikeResponseSendPort.send(req);
      }
    }
  }
}
