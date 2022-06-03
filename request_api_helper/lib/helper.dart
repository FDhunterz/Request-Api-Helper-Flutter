import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart' show RequestApiHelper;
import 'package:webview_flutter/webview_flutter.dart';

Future<dynamic> timeTracker(name, Function function, {RequestApiHelperData? config}) async {
  DateTime? now;
  if (config?.debug == true) {
    now = DateTime.now();
  }
  final res = await function();

  if (config?.debug == true) {
    print('$name ' + DateTime.now().difference(now!).inMilliseconds.toString() + ' Millisecond');
  }
  return res;
}

notNullFill(dynamic base, dynamic newData) {
  if (newData != null) {
    return newData;
  }
  return base;
}

handlingData(data, {bool debug = false}) {
  if (data is Map) {
    if (debug) {
      print(data.toString() + ' // Map');
    }
  } else if (data is List) {
    if (debug) {
      print(data.toString() + ' // List');
    }
  } else if (data is String) {
    if (debug) {
      if (data.contains('<script>') || data.contains('</script>')) {
        if (RequestApiHelper.baseData?.navigatorKey != null) {
          late WebViewController _controller;
          showDialog(
            context: RequestApiHelper.baseData!.navigatorKey!.currentContext!,
            builder: (context) {
              return Scaffold(
                body: StatefulBuilder(builder: (context, state) {
                  return WebView(
                      initialUrl: 'about:blank',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller = webViewController;
                        _controller.loadUrl(Uri.dataFromString(data, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
                        state(() {});
                      });
                }),
              );
            },
          );
        }
      }
    }
  } else if (data is int) {
    if (debug) {
      print(data.toString() + ' // integer');
    }
  } else if (data is double) {
    if (debug) {
      print(data.toString() + ' // double');
    }
  }
}
