import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:request_api_helper/helper/session.dart';

class ENV {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static ENVData? _data;
  static ENVData? get data => _data;
  static ENV? _globalData;
  static ENV? get globalData => _globalData;
  static final config = ENV._init();
  
  ENV._init() {
    Session.init(encrypted: true);
  }

  save(ENVData data) {
    _data = data;
    _globalData = this;
  }
}

class ENVData {
  bool ignoreBadCertificate;
  bool? debug;
  String? baseUrl;
  Duration? timeoutDuration;
  bool isLoading;
  String? replacementId;
  RequestData? globalData;
  Future<void> Function(int start, int total)? onProgress;
  Future<void> Function(Response error)? onError;
  Future<void> Function(Response success)? onSuccess;
  Future<void> Function(Object exception)? onException;
  Future<void> Function(Object exception)? onTimeout;
  Future<void> Function(BuildContext context)? onAuthError;

  String? getUrl() {
    return (baseUrl ?? '') + (globalData?.url ?? '');
  }

  Future<List<int>> convertUTF8() async {
    globalData?.header!.addAll({
      'content-type': 'application/json',
    });
    return utf8.encode(await compute(json.encode, globalData!.body));
  }

  ENVData({
    this.isLoading = false,
    this.onError,
    this.onProgress,
    this.onSuccess,
    this.onException,
    this.baseUrl,
    this.onTimeout,
    this.timeoutDuration,
    this.debug = false,
    this.ignoreBadCertificate = false,
    this.globalData,
    this.onAuthError,
    this.replacementId,
  });
}

class RequestData {
  String? url;
  Map<String, String>? header;
  Map<String, dynamic>? body;
  List<FileData>? file;

  String getParams() {
    if (body == null) return '';
    String param = '?';
    body?.forEach((key, value) {
      param += '$key=${value.toString().replaceAll(' ', '%20')}';
      param += '&';
    });

    return param.substring(0, param.length - 1);
  }

  parseFile(MultipartRequest request) async {
    for (int counterfile = 0; counterfile < (file!).length; counterfile++) {
      if (file![counterfile].path == '' || file![counterfile].requestName == 'null') {
        request.fields[file![counterfile].requestName] = 'null';
      } else {
        request.files.add(await MultipartFile.fromPath(file![counterfile].requestName, file![counterfile].path, contentType: MediaType('application', file![counterfile].path.split('.').last)));
      }
    }
  }

  RequestData({this.body, this.header, this.url, this.file}) {
    file ??= [];
  }
}

class FileData {
  String path, requestName;

  FileData({required this.path, required this.requestName});
}
