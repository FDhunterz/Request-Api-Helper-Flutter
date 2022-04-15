import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:request_api_helper/model/request_file.dart';

import '../helper.dart';
import '../request.dart';
import '../session.dart';

enum Api { post, get, put, delete }

List<RequestStack> requestStack = [];

class RequestStack {
  UniqueKey id;
  int? replacementId;
  StreamSubscription stream;
  bool runInBackground;
  BuildContext currentContext;

  RequestStack({required this.stream, this.replacementId, required this.id, required this.currentContext, this.runInBackground = false});
}

class RequestApiHelper {
  static RequestApiHelperData? baseData;

  static Future<void> save(RequestApiHelperData data) async {
    baseData ??= RequestApiHelperData();
    baseData!.baseUrl = notNullFill(baseData!.baseUrl, data.baseUrl);
    baseData!.body = notNullFill(baseData!.body, data.body);
    baseData!.header = notNullFill(baseData!.header, data.header);
    baseData!.bodyIsJson = notNullFill(baseData!.bodyIsJson, data.bodyIsJson);
    baseData!.debug = notNullFill(baseData!.debug, data.debug);
    baseData!.navigatorKey = notNullFill(baseData!.navigatorKey, data.navigatorKey);
    baseData!.file = notNullFill(baseData!.file, data.file);
  }

  static Future<RequestApiHelperData> _getCustomConfig(RequestApiHelperData data) async {
    final _data = RequestApiHelperData();
    _data.baseUrl = notNullFill(baseData!.baseUrl, data.baseUrl);
    _data.body = notNullFill(baseData!.body, data.body);
    _data.header = notNullFill(baseData!.header, data.header);
    _data.bodyIsJson = notNullFill(baseData!.bodyIsJson, data.bodyIsJson);
    _data.onSuccess = notNullFill(baseData!.onSuccess, data.onSuccess);
    _data.debug = notNullFill(baseData!.debug, data.debug);
    _data.navigatorKey = notNullFill(baseData!.navigatorKey, data.navigatorKey);
    _data.file = notNullFill(baseData!.file, data.file);
    return _data;
  }

  static Future<void> init(RequestApiHelperData data) async {
    await Session.init();
    await save(data);
  }

  static initState() async {
    requestStack.where((element) => element.currentContext == baseData!.navigatorKey!.currentContext && element.runInBackground == false).map((e) => e.stream.cancel()).toList();
    requestStack.removeWhere((element) => element.currentContext == baseData!.navigatorKey!.currentContext && element.runInBackground == false);
  }

  static Future<RequestStack> sendRequest({
    url,
    required Api type,
    RequestApiHelperData? config,
    int? replacementId,
    bool runInBackground = false,
    Function(int uploaded, int total)? onUploadProgress,
  }) async {
    UniqueKey keys = UniqueKey();
    final RequestApiHelperData getConfig = config == null ? baseData! : (await _getCustomConfig(config));
    if (replacementId != null) {
        final getStack = requestStack.where((element) => element.replacementId == replacementId);
        if (getStack.isNotEmpty) {
          getStack.first.stream.cancel();
          requestStack.removeWhere((element) => element.replacementId == replacementId);
        }
    }
    final send = RequestStack(
      id: keys,
      replacementId: replacementId,
      currentContext: getConfig.navigatorKey!.currentContext!,
      runInBackground: runInBackground,
      stream: request(
        type: type,
        url: url,
        config: getConfig,
        onUploadProgress: onUploadProgress,
      ).asStream().listen(
        (response) async {
          final res = response as Response;
          if (getConfig.onSuccess != null) {
            dynamic decode;
            try {
              decode = await compute(json.decode, res.body);
            } catch (_) {
              handlingData(res.body, debug: getConfig.debug);
            }
            getConfig.onSuccess!(decode);
          }
          requestStack.removeWhere((element) => element.id == keys);
        },
      ),
    );
    requestStack.add(send);
    return send;
  }

  static Future<dynamic> request({url, required Api type, required RequestApiHelperData config, Function(int uploaded, int total)? onUploadProgress}) async {
    String? token = await Session.load('token');
    dynamic body;
    config.header ??= {
      'Accept': 'application/json',
    };

    if (token != null) config.header!.addAll({'Authorization': token});
    if (config.bodyIsJson && type != Api.get) {
      config.header!.addAll({
        'content-type': 'application/json',
      });
      body = utf8.encode(await compute(json.encode, config.body));
    } else {
      body = '';

      if (config.body is Map) {
        body = '?';
        int _counter = 0;
        config.body!.forEach((key, value) {
          ++_counter;
          if (!(_counter == config.body!.length)) {
            body += '$key=$value&';
          } else {
            body += '$key=$value';
          }
        });
      }
    }
    if (type == Api.post) {
      if (config.file != null) {
        final newConfig = config;
        newConfig.baseUrl = config.baseUrl! + url;
        return await requestfile(newConfig, onUploadProgress: onUploadProgress);
      } else {
        return await post(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
      }
    } else if (type == Api.get) {
      return await get(Uri.parse(config.baseUrl! + url), headers: config.header!);
    } else if (type == Api.put) {
      return await put(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
    } else if (type == Api.delete) {
      return await delete(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
    }
    return null;
  }
}
