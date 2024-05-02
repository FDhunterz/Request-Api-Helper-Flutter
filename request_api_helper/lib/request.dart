import 'dart:convert';

import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/helper/null_fill.dart';
import 'package:request_api_helper/helper/track.dart';
import 'package:request_api_helper/loding.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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

  Future<http.Response?> _methodDeploy(
      ENVData data, Future<http.Response?> Function() method) async {
    try {
      if (data.isLoading) {
        Loading.start();
      }
      final d = await method();
      if(d == null){
        return null;
      }
      if (data.onSuccess == null && data.onError == null) {
        Track.debug('raw response api');
        return d;
      } else {
        if ((d.statusCode ) >= 200 && (d.statusCode ) <= 210) {
          if (data.onSuccess != null) await data.onSuccess!(d);
        } else if ((d.statusCode ) == 401) {
          if (data.onAuthError != null)
            await data.onAuthError!(d, ENV.navigatorKey.currentContext!);
        } else {
      print(d);
          if (data.onError != null) await data.onError!(d);
        }
        Track.debug('response process done');
      }
      return null;
    } catch (_) {
      if (data.onException != null) await data.onException!(_);
        Track.debug('exception process done');
    }
    return null;
  }

  Future<http.Response?> post({bool dynamicJson = false}) async {
    final random = getRandomString(10);

    final ENVData data = readConfig();
    await _methodDeploy(data, () async {
      final token = await Session.load('token');
      data.replacementId ??= random;

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null)
        data.globalData?.header!.addAll({'Authorization': token!});
      final d = await APIMultiThread().config(data).run(Api.post);
      if (data.isLoading && !Loading.loadingProgress()) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<http.Response?> get() async {
    Track.start();
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      data.replacementId ??= random;

      final token = await Session.load('token');
      Track.debug('load token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null)
        data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.get);
      // final d =  await http.get(Uri.parse((data.getUrl() ?? '') + (data.globalData?.getParams() ?? '')),headers: data.globalData?.header);
      Track.debug('api done');

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }

      if (!Loading.loadingProgress()) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<http.Response?> put() async {
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      data.replacementId ??= random;

      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null)
        data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.put);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }
      if (!Loading.loadingProgress()) {
        Loading.close();
      }
      return d;
    });
    return null;
  }

  Future<http.Response?> delete() async {
    final random = getRandomString(10);
    final ENVData data = readConfig();
    _alertNotPost(data);
    await _methodDeploy(data, () async {
      data.replacementId ??= random;

      final token = await Session.load('token');

      data.globalData?.header ??= {
        'Accept': 'application/json',
      };

      if (token != null)
        data.globalData?.header!.addAll({'Authorization': token!});

      final d = await APIMultiThread().config(data).run(Api.delete);

      if (data.isLoading) {
        Loading.requestStack.remove(data.replacementId ?? random);
      }
      if (!Loading.loadingProgress()) {
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
  bool? withLoading, processOnlyThisPage;
  String? replacementId;
  List<FileData>? file;
  Future<void> Function(int start, int total)? onProgress;
  Future<void> Function(http.Response error)? onError;
  Future<void> Function(http.Response error, BuildContext context)? onAuthError;
  Future<void> Function(http.Response success)? onSuccess;
  Future<void> Function(Object exception)? onException;
  Future<void> Function(Object exception)? onTimeout;

  ENVData _convertENVData(ENVData baseConfig) {
    return ENVData(
      baseUrl: NullFill.state().converter(baseUrl, baseConfig.baseUrl),
      onError: NullFill.state().converter(onError, baseConfig.onError),
      onSuccess: NullFill.state().converter(onSuccess, baseConfig.onSuccess),
      processOnlyThisPage: NullFill.state().converter(processOnlyThisPage, baseConfig.processOnlyThisPage),
      onException:
          NullFill.state().converter(onException, baseConfig.onException),
      onTimeout: NullFill.state().converter(onTimeout, baseConfig.onTimeout),
      onProgress: NullFill.state().converter(onProgress, baseConfig.onProgress),
      onAuthError:
          NullFill.state().converter(onAuthError, baseConfig.onAuthError),
      debug: baseConfig.debug,
      ignoreBadCertificate: baseConfig.ignoreBadCertificate,
      timeoutDuration: baseConfig.timeoutDuration,
      isLoading: NullFill.state().converter(withLoading, baseConfig.isLoading),
      replacementId: replacementId,
      globalData: RequestData(
        body: NullFill.state().converter(body, baseConfig.globalData?.body),
        header:
            NullFill.state().converter(header, baseConfig.globalData?.header),
        url: NullFill.state().converter(url, baseConfig.globalData?.url),
        file: NullFill.state().converter(file, baseConfig.globalData?.url),
      ),
    );
  }
}
