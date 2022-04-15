import 'package:flutter/cupertino.dart';

class FileData {
  List<String> path;
  List<String> requestName;

  FileData({required this.path, required this.requestName});
}

class RequestApiHelperData {
  String? baseUrl;
  Map<String, dynamic>? body;
  Map<String, String>? header;
  bool bodyIsJson = false;
  Function(dynamic)? onSuccess;
  GlobalKey<NavigatorState>? navigatorKey;
  bool debug;
  FileData? file;

  RequestApiHelperData({
    this.baseUrl,
    this.body,
    this.bodyIsJson = false,
    this.header,
    this.onSuccess,
    this.debug = false,
    this.navigatorKey,
    this.file,
  });
}
