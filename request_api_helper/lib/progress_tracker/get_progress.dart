import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:request_api_helper/request.dart';

Future<Response> getProgress({baseUrl, url, body, RequestApiHelperData? config, Function(int, int)? onProgress}) async {
  final req = HttpClient();
  final res = await req.getUrl(Uri.parse(baseUrl + url + body));

  config?.header?.forEach((key, value) {
    res.headers.add(key, value);
  });
  final closeRes = await res.close();
  final output = await consolidateHttpClientResponseBytes(
    closeRes,
    onBytesReceived: (downloaded, total) {
      if (onProgress != null) {
        onProgress(downloaded, (total ?? -1));
      }
    },
  );
  final parse = await compute(utf8.decode, output);
  return Response(parse, closeRes.statusCode);
}
