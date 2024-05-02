import 'package:request_api_helper/global_env.dart';
import 'package:flutter/material.dart';
import 'package:request_api_helper/request.dart';
import 'dart:isolate';
import 'dart:async';
import 'package:sql_query/random.dart';

class Streams {
  String id;
  bool isLoading, processOnlyThisPage;
  StreamSubscription stream;
  Streams({required this.stream, required this.id,this.isLoading = false, this.processOnlyThisPage = true});
}

class Loading {
  static List<String> requestStack = [];
  static List<Streams> stack = [];
  static Widget? widget;
  static bool _isLoading = false;
  static loadingProgress(){
    return stack.where((element) => element.isLoading).isNotEmpty;
  }

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
