import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:request_api_helper/loading.dart';
import 'package:request_api_helper/model/request_file.dart';

import '../helper.dart';
import '../request.dart';
import '../session.dart';

enum Api { post, get, put, delete }

// class RequestApiHelperObserver extends NavigatorObserver {
//   @override
//   void didPop(Route route, Route? previousRoute) {
//     print(route);
//     super.didPop(route, previousRoute);
//   }

//   @override
//   void didPush(Route route, Route? previousRoute) {
//     print(route);
//     super.didPush(route, previousRoute);
//   }
// }

List<RequestStack> requestStack = [];

class RequestStack {
  UniqueKey id;
  int? replacementId;
  StreamSubscription stream;
  bool runInBackground;
  bool withLoading;
  BuildContext currentContext;

  RequestStack({required this.stream, this.replacementId, required this.id, required this.currentContext, this.runInBackground = false, this.withLoading = false});
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
    baseData!.onError = notNullFill(baseData!.onError, data.onError);
    baseData!.onAuthError = notNullFill(baseData!.onAuthError, data.onAuthError);
    baseData!.timeout = notNullFill(baseData!.timeout, data.timeout);
    baseData!.onTimeout = notNullFill(baseData!.onTimeout, data.onTimeout);
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
    _data.onError = notNullFill(baseData!.onError, data.onError);
    _data.onAuthError = notNullFill(baseData!.onAuthError, data.onAuthError);
    _data.onTimeout = notNullFill(baseData!.onTimeout, data.onTimeout);
    _data.timeout = notNullFill(baseData!.timeout, data.timeout);
    print(_data.timeout);
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
    bool withLoading = false,
  }) async {
    UniqueKey keys = UniqueKey();
    final RequestApiHelperData getConfig = config == null ? baseData! : (await _getCustomConfig(config));
    int getLength = requestStack.where((element) => element.withLoading == true).length;
    if (getLength == 0 && withLoading) {
      Loading.start();
    }
    if (replacementId != null) {
      final getStack = requestStack.where((element) => element.replacementId == replacementId);
      if (getStack.isNotEmpty) {
        getStack.first.stream.cancel();
        requestStack.removeWhere((element) => element.replacementId == replacementId);
      }
    }
    print(getConfig.timeout);
    final send = RequestStack(
      id: keys,
      replacementId: replacementId,
      currentContext: getConfig.navigatorKey!.currentContext!,
      runInBackground: runInBackground,
      withLoading: withLoading,
      stream: request(
        type: type,
        url: url,
        config: getConfig,
        onUploadProgress: onUploadProgress,
      )
          .timeout(getConfig.timeout!)
          .onError((error, stackTrace) async {
            if (error.toString().contains('TimeoutException')) {
              final getStack = requestStack.where((element) => element.id == keys);
              getStack.first.stream.cancel();
              requestStack.removeWhere((element) => element.id == keys);
              if (getConfig.onTimeout != null) {
                await timeTracker('Timeout Clear', () async {
                  await getConfig.onTimeout!(Response(json.encode({'message': 'timeout'}), 408));
                }, config: config);
              }
            }
          })
          .asStream()
          .listen(
            (response) async {
              if (!(response == null)) {
                final res = response as Response;
                dynamic decode;
                requestStack.removeWhere((element) => element.id == keys);
                int getLength = requestStack.where((element) => element.withLoading == true).length;
                if (getLength == 0 && withLoading) {
                  Loading.end();
                }

                if (res.statusCode == 401) {
                  if (getConfig.onAuthError != null) {
                    getConfig.onAuthError!(getConfig.navigatorKey!.currentContext!);
                  }
                } else {
                  try {
                    if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 202) {
                      if (getConfig.onSuccess != null) {
                        decode = await compute(json.decode, res.body);
                        timeTracker('onSuccess Clear', () async {
                          await getConfig.onSuccess!(decode);
                        }, config: config);
                      }
                    } else if (getConfig.onError != null) {
                      decode = await compute(json.decode, res.body);
                      handlingData(decode, debug: getConfig.debug!);
                      timeTracker('onError Clear', () async {
                        await getConfig.onError!(res);
                      }, config: config);
                    }
                  } catch (_) {
                    handlingData(res.body, debug: getConfig.debug!);
                  }
                }
              }
            },
          ),
    );
    requestStack.add(send);
    return send;
  }

  static Future<dynamic> request({url, required Api type, required RequestApiHelperData config, Function(int uploaded, int total)? onUploadProgress}) async {
    String? token;
    await timeTracker('Load Token ($url)', () async {
      token = await Session.load('token');
    }, config: config);
    dynamic body;
    config.header ??= {
      'Accept': 'application/json',
    };

    if (token != null) config.header!.addAll({'Authorization': token!});
    if (config.bodyIsJson && type != Api.get) {
      config.header!.addAll({
        'content-type': 'application/json',
      });
      body = utf8.encode(await compute(json.encode, config.body));
    } else if (type != Api.get) {
      body = config.body;
    } else {
      body = '';

      if (config.body is Map) {
        int _counter = 0;
        body = '?';
        config.body!.forEach((key, value) {
          ++_counter;
          if (value != '' && value != null) {
            if (!(_counter == config.body!.length)) {
              body += '$key=$value&';
            } else {
              body += '$key=$value';
            }
          }
        });
      }
    }
    if (type == Api.post) {
      if (config.file != null) {
        final newConfig = config;
        newConfig.baseUrl = config.baseUrl! + url;

        return await timeTracker('Request Post File ($url)', () async {
          return await requestfile(newConfig, onUploadProgress: onUploadProgress);
        }, config: config) as Response?;
      } else {
        return await timeTracker('Request Post  ($url)', () async {
          return await post(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
        }, config: config) as Response?;
      }
    } else if (type == Api.get) {
      return await timeTracker('Request Get  ($url)', () async {
        return await get(Uri.parse(config.baseUrl! + url + body), headers: config.header!);
      }, config: config) as Response?;
    } else if (type == Api.put) {
      return await timeTracker('Request Put  ($url)', () async {
        return await put(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
      }, config: config) as Response?;
    } else if (type == Api.delete) {
      return await timeTracker('Request Delete  ($url)', () async {
        return await delete(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
      }, config: config) as Response?;
    }
    return null;
  }
}
