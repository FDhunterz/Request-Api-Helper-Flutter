import 'package:flutter/material.dart';
import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/loding.dart';

class Navigate{
  static _remove(){
      Loading.stack.where((element) => element.processOnlyThisPage).map((e) {
        e.stream.cancel();
      }).toList();
  }
  static push<T>(Route<T> route) async {
    _remove();
    final navigator = await Navigator.push(ENV.navigatorKey.currentContext!, route);
    
    return navigator;
  }
  
  static pushAndRemoveUntil<T>(Route<T> route) async {
    _remove();
    return await Navigator.pushAndRemoveUntil(
        ENV.navigatorKey.currentContext!, route, (route) => false);
  }
}