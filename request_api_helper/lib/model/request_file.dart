import 'dart:convert';
import 'dart:io';
import 'dart:async';

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
