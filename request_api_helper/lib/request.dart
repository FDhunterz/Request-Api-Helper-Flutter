import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

/// Of `RequestApiHelperData`,`RequestApiHelperDownloadData`
abstract class RequestApiHelperConfig {}

class FileData {
  List<String> path;
  List<String> requestName;

  FileData({required this.path, required this.requestName});
}

class RequestApiHelperDownloader {
  String? name, path, url;

  RequestApiHelperDownloader({this.path, this.name, this.url});
}

class RequestApiHelperDownloadData extends RequestApiHelperConfig {
  String? path, thumnailPath, nameFile;
  Function(dynamic)? onSuccess;
  Function(Response)? onError;

  Duration? timeout;
  RequestApiHelperDownloadData({
    this.path,
    this.thumnailPath,
    this.onSuccess,
    this.onError,
    this.timeout,
    this.nameFile,
  });
}

class RequestApiHelperData extends RequestApiHelperConfig {
  String? baseUrl;
  Map<String, dynamic>? body;
  Map<String, String>? header;
  bool bodyIsJson = false;
  Function(dynamic)? onSuccess;
  Function(Response)? onError;
  Function(BuildContext)? onAuthError;
  Function(Response)? onTimeout;
  GlobalKey<NavigatorState>? navigatorKey;
  bool? debug;
  FileData? file;
  Duration? timeout;

  RequestApiHelperData({
    this.baseUrl,
    this.body,
    this.bodyIsJson = false,
    this.header,
    this.onSuccess,
    this.debug,
    this.navigatorKey,
    this.file,
    this.onAuthError,
    this.onError,
    this.timeout,
    this.onTimeout,
  });
}
