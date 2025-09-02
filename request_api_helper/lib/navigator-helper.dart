import 'package:flutter/material.dart';
import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/loding.dart';

class Navigate {
  static Route<dynamic> Function({Widget page})? routeSetting;
  static Function()? afterPop;
  static _remove() {
    Loading.stack.where((element) => element.processOnlyThisPage).map((e) {
      e.stream?.cancel();
    }).toList();
  }

  static push<T>(Widget page, {bool removeObserver = true}) async {
    _remove();
    final navigator = await Navigator.push(ENV.navigatorKey.currentContext!, routeSetting!(page: page));

    return navigator;
  }

  static pushAndRemoveUntil<T>(Widget page, {bool removeObserver = true}) async {
    _remove();
    return await Navigator.pushAndRemoveUntil(
        ENV.navigatorKey.currentContext!, routeSetting!(page: page), (route) => false);
  }

  static void pop<T>([bool removeObserver = true, dynamic data]) async {
    _remove();
    Navigator.pop(ENV.navigatorKey.currentContext!, data);
    if (afterPop != null) {
      afterPop!();
    }
  }
}
