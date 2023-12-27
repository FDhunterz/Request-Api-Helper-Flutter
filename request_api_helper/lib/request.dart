import 'dart:convert';

import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/helper/null_fill.dart';
import 'package:request_api_helper/loding.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:sql_query/random.dart';

import 'helper/session.dart';
import 'multi_thread.dart';

class API extends APIFunction {
  static final state = API._state();

  API._state();

  API();

  ENVData readConfig() {
    return _convertENVData(ENV.data ?? ENVData());
  }

  _alertNotPost(ENVData data) {
    if (data.debug ?? false) {
      if (data.globalData?.file?.isNotEmpty ?? false) print('FILE IS NOT USED');
    }
  }

  Future<Response?> _methodDeploy(ENVData data, Future<Response?> Function() method) async {
    try {
      if (Loading.requestStack.where((element) => element == data.replacementId).isNotEmpty) {
        return null;
      }
      if (data.isLoading) {
        Loading.start();
      }
      final d = await method();
      if (data.onSuccess == null && data.onError == null) {
        return d;
      } else {
        if ((d?.statusCode ?? 666) >= 200 && (d?.statusCode ?? 666) <= 210) {
          if (data.onSuccess != null) await data.onSuccess!(d!);
        } else if ((d?.statusCode ?? 666) == 401) {
          if (data.onAuthError != null) await data.onAuthError!(ENV.navigatorKey.currentContext!);
        } else {
          if (data.onError != null) await data.onError!(d!);
        }
      }
      return null;
    } catch (_) {
      if (data.onException != null) await data.onException!(Response(json.encode({'message': _.toString}), 666));
    }
    return null;
  }

  Future<Response?> post({bool dynamicJson = false}) async {
    final random = getRandomString(10);

    final ENVData data = readConfig();
    await _methodDeploy(data, () async {
      if (data.isLoading) {
        Loading.requestStack.add(data.replacementId ?? random);
      }
      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null) data.globalData?.header!.addAll({'Authorization': token!});
      final d = await APIMultiThread().config(data).run(Api.post);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }
      if (data.isLoading && Loading.requestStack.isEmpty) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<Response?> get() async {
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      if (data.isLoading) {
        Loading.requestStack.add(data.replacementId ?? random);
      }
      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null) data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.get);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }

      if (Loading.requestStack.isEmpty) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<Response?> put() async {
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      if (data.isLoading) {
        Loading.requestStack.add(data.replacementId ?? random);
      }
      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null) data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.put);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }
      if (Loading.requestStack.isEmpty) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<Response?> delete() async {
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      if (data.isLoading) {
        Loading.requestStack.add(data.replacementId ?? random);
      }
      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null) data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.delete);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }
      if (Loading.requestStack.isEmpty) {
        Loading.close();
      }
      return d;
    });
    return null;
  }
}

abstract class APIFunction {
  String? url;
  String? baseUrl;
  Map<String, dynamic>? body;
  Map<String, String>? header;
  bool? withLoading;
  String? replacementId;
  List<FileData>? file;
  Future<void> Function(int start, int total)? onProgress;
  Future<void> Function(Response error)? onError;
  Future<void> Function(BuildContext context)? onAuthError;
  Future<void> Function(Response success)? onSuccess;
  Future<void> Function(Object exception)? onException;
  Future<void> Function(Object exception)? onTimeout;

  ENVData _convertENVData(ENVData baseConfig) {
    return ENVData(
      baseUrl: NullFill.state().converter(baseUrl, baseConfig.baseUrl),
      onError: NullFill.state().converter(onError, baseConfig.onError),
      onSuccess: NullFill.state().converter(onSuccess, baseConfig.onSuccess),
      onException: NullFill.state().converter(onException, baseConfig.onException),
      onTimeout: NullFill.state().converter(onTimeout, baseConfig.onTimeout),
      onProgress: NullFill.state().converter(onProgress, baseConfig.onProgress),
      onAuthError: NullFill.state().converter(onAuthError, baseConfig.onAuthError),
      debug: baseConfig.debug,
      ignoreBadCertificate: baseConfig.ignoreBadCertificate,
      timeoutDuration: baseConfig.timeoutDuration,
      isLoading: NullFill.state().converter(withLoading, baseConfig.isLoading),
      replacementId: replacementId,
      globalData: RequestData(
        body: NullFill.state().converter(body, baseConfig.globalData?.body),
        header: NullFill.state().converter(header, baseConfig.globalData?.header),
        url: NullFill.state().converter(url, baseConfig.globalData?.url),
        file: NullFill.state().converter(file, baseConfig.globalData?.url),
      ),
    );
  }
}
