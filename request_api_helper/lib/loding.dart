import 'package:request_api_helper/global_env.dart';
import 'package:flutter/material.dart';

class Loading {
  static List<String> requestStack = [];
  static Widget? widget;
  static bool _isLoading = false;

  static start() {
    if (widget == null) return;
    if (!_isLoading) {
      _isLoading = true;
      showDialog(
        barrierDismissible: false,
        context: ENV.navigatorKey.currentContext!,
        builder: (context) {
          return widget!;
        },
      );
    }
  }

  static close() {
    if (_isLoading) {
      _isLoading = false;
      Navigator.pop(ENV.navigatorKey.currentContext!);
    }
  }
}
