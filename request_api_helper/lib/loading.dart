import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:request_api_helper/request_api_helper.dart';

class Loading {
  static bool loading = false;
  static BuildContext? currentContext;
  static BuildContext? lastContext;
  static Timer? delay;
  static Function(BuildContext)? widget;

  static widgets() async {
    if (widget != null) {
      await widget!(RequestApiHelper.baseData!.navigatorKey!.currentContext!);
    }
  }

  static start() {
    if (!loading) {
      loading = true;
      widgets();
    }
  }

  static end() {
    if (delay != null) {
      delay!.cancel();
    }
    if (loading) {
      loading = false;
      if (currentContext == (lastContext ?? RequestApiHelper.baseData!.navigatorKey!.currentContext!)) {
        Navigator.pop(RequestApiHelper.baseData!.navigatorKey!.currentContext!);
      }
    }
  }
}
