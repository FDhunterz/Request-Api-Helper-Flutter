import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:request_api_helper/helper/database.dart';
import 'package:request_api_helper/loading.dart';
import 'package:request_api_helper/model/request_file.dart';
import 'package:request_api_helper/progress_tracker/get_progress.dart';

import '../helper.dart';
import '../request.dart';
import '../session.dart';
import 'helper/isolate.dart';
export 'material/app.dart';

enum Api { post, get, put, delete, download }

GlobalKey<NavigatorState>? navigatorKey;

class RequestApiHelperObserver extends NavigatorObserver {
  final Function(Route, Route?)? didPopFunction;
  final Function(Route, Route?)? didPushFunction;

  RequestApiHelperObserver({this.didPopFunction, this.didPushFunction});

  @override
  void didPop(Route route, Route? previousRoute) {
    Loading.loading = false;
    RequestApiHelper.nowRoute = route;
    RequestApiHelper.initState(hasContext: previousRoute?.navigator?.context);
    if (didPopFunction != null) {
      didPopFunction!(route, previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    RequestApiHelper.nowRoute = previousRoute;
    RequestApiHelper.initState(hasContext: previousRoute?.navigator?.context);
    if (didPushFunction != null) {
      didPushFunction!(route, previousRoute);
    }
    super.didPush(route, previousRoute);
  }
}

List<RequestStack> requestStack = [];

class RequestStack {
  UniqueKey id;
  int? replacementId;
  StreamSubscription stream;
  bool runInBackground;
  bool withLoading;
  int repeat;
  BuildContext currentContext;
  Route? route;

  RequestStack({required this.stream, this.replacementId, required this.id, required this.currentContext, this.runInBackground = false, this.withLoading = false, this.route, this.repeat = 0});
}

class RequestApiHelper {
  /// Of `RequestApiHelperData`,`RequestApiHelperDownloadData`
  static RequestApiHelperData? baseData;
  static Route? nowRoute;
  static Route? loadingRoute;
  static int totalDataUsed = 0;
  static StreamController _downloadController = StreamController();
  static List<DownloadQueue> _downloadQueue = [];
  static List<DownloadAdd> _downloadProcess = [];
  static List<String> log = [];
  static int _maxDownload = 10;
  static bool _multithread = false;
  static bool _openAllSecurityForMultiThread = false;

  static addLog(String command) {
    if (log.length > 500) {
      log.removeAt(0);
    }
    log.add(command);
  }

  static Future to({Route? route, String? name, Object? arguments}) async {
    if (route != null) {
      return await Navigator.push(navigatorKey!.currentContext!, route);
    } else if (name != null) {
      return await Navigator.pushNamed(navigatorKey!.currentContext!, name, arguments: arguments);
    }
  }

  static Future replaceTo(Route route) async {
    return await Navigator.pushAndRemoveUntil(navigatorKey!.currentContext!, route, (route) => false);
  }

  static Future replaceNameTo(String route, {Object? arguments}) async {
    return await Navigator.pushNamedAndRemoveUntil(navigatorKey!.currentContext!, route, (route) => false, arguments: arguments);
  }

  static Future<void> save(RequestApiHelperConfig data, {bool initial = false, int maxDownload = 10}) async {
    _maxDownload = maxDownload;
    if (data is RequestApiHelperData) {
      baseData ??= RequestApiHelperData();

      if (initial) {
        baseData!.navigatorKey ??= GlobalKey<NavigatorState>();
        navigatorKey ??= baseData!.navigatorKey;
      }
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
      if (data.navigatorKey != null) {
        navigatorKey = baseData!.navigatorKey;
      }
    }
  }

  static Future<RequestApiHelperData> _getCustomConfig(RequestApiHelperConfig data) async {
    if (data is RequestApiHelperData) {
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
      return _data;
    }
    return RequestApiHelperData();
  }

  static Future<void> init(RequestApiHelperConfig data, {int maxDownload = 10, bool encryptedSession = false, bool useMultiThread = true, bool openAllSecurityForMultiThread = false}) async {
    _multithread = useMultiThread;
    _openAllSecurityForMultiThread = openAllSecurityForMultiThread;
    if (!_downloadController.hasListener) {
      _downloadController.stream.listen((event) {
        if (event is DownloadAdd) {
          _downloadProcess.add(event);
        } else if (event is DownloadDone) {
          _downloadProcess.removeWhere((element) => element.id == event.id);
          if (_downloadQueue.length > 0) {
            final getData = _downloadQueue.first;
            sendRequest(
              type: Api.download,
              config: getData.data,
              onProgress: getData.onProgress,
              url: getData.url,
              runInBackground: true,
            );
            _downloadQueue.remove(getData);
          }
        } else if (event is DownloadQueue) {
          _downloadQueue.add(event);
        }
      });
    }
    await Session.init(
      encrypted: encryptedSession,
    );
    await save(data, initial: true, maxDownload: maxDownload);
  }

  static initState({BuildContext? hasContext}) async {
    requestStack.where((element) => (element.currentContext != (hasContext ?? baseData!.navigatorKey!.currentContext) || (element.route != nowRoute && !Loading.loading)) && element.runInBackground == false).map((e) {
      e.stream.cancel();
    }).toList();
    requestStack.removeWhere((element) => (element.currentContext != (hasContext ?? baseData!.navigatorKey!.currentContext) || (element.route != nowRoute && !Loading.loading)) && element.runInBackground == false);
  }

  static StreamSubscription _requests({type, url, getConfig, config, onProgress, withLoading, keys, repeat = 0}) {
    return request(
      type: type,
      url: url,
      config: getConfig,
      download: config is RequestApiHelperDownloadData ? config : null,
      onProgress: onProgress,
    )
        .timeout(getConfig.timeout ?? Duration(seconds: 60))
        .onError((error, stackTrace) async {
          if (error.toString().contains('TimeoutException')) {
            Loading.end();
            final getStack = requestStack.where((element) => element.id == keys);
            requestStack.removeWhere((element) => element.id == keys);
            if (getConfig.onTimeout != null) {
              await timeTracker('Timeout Clear', () async {
                await getConfig.onTimeout!(Response(json.encode({'message': 'timeout'}), 408));
              }, config: (config is RequestApiHelperData) ? config : baseData);
            }
            if (repeat > 0) {
              handlingData('Repeat $repeat', debug: getConfig.debug!);
              _requests(
                type: type,
                url: url,
                getConfig: getConfig,
                config: config,
                onProgress: onProgress,
                withLoading: withLoading,
                keys: keys,
                repeat: repeat - 1,
              );
            } else {
              getStack.first.stream.cancel();
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
                      }, config: (config is RequestApiHelperData) ? config : baseData);
                    }
                  } else if (getConfig.onError != null) {
                    if (repeat > 0) {
                      handlingData('Repeat $repeat', debug: getConfig.debug!);
                      _requests(
                        type: type,
                        url: url,
                        getConfig: getConfig,
                        config: config,
                        onProgress: onProgress,
                        withLoading: withLoading,
                        keys: keys,
                        repeat: repeat - 1,
                      );
                    }
                    decode = await compute(json.decode, res.body);
                    handlingData(decode, debug: getConfig.debug!);

                    timeTracker('onError Clear', () async {
                      await getConfig.onError!(res);
                    }, config: (config is RequestApiHelperData) ? config : baseData);
                  }
                } catch (_) {
                  handlingData(res.body, debug: getConfig.debug!);
                  internalHandlingData(_.toString(), debug: getConfig.debug!);
                }
              }
            }
          },
        );
  }

  static Future<RequestStack> sendRequest({
    url,
    required Api type,

    /// Of `RequestApiHelperData`,`RequestApiHelperDownloadData`
    RequestApiHelperConfig? config,
    int? replacementId,
    bool runInBackground = false,
    Function(int current, int total)? onProgress,
    bool withLoading = false,
    int repeat = 0,
  }) async {
    UniqueKey keys = UniqueKey();
    RequestApiHelperData getConfig;
    if (config is RequestApiHelperData) {
      getConfig = (await _getCustomConfig(config));
    } else {
      getConfig = baseData!;
    }
    int getLength = requestStack.where((element) => element.withLoading == true).length;

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
      withLoading: withLoading,
      repeat: repeat,
      route: nowRoute,
      stream: _requests(
        type: type,
        url: url,
        getConfig: getConfig,
        config: config,
        onProgress: onProgress,
        withLoading: withLoading,
        keys: keys,
        repeat: repeat,
      ),
    );
    requestStack.add(send);
    if (getLength == 0 && withLoading) {
      Loading.start();
    }
    return send;
  }

  static Future<dynamic> request({url, required Api type, required RequestApiHelperData config, RequestApiHelperDownloadData? download, Function(int uploaded, int total)? onProgress}) async {
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
      if (onProgress != null) {
        final newConfig = config;
        newConfig.baseUrl = config.baseUrl! + url;
        newConfig.header = config.header;

        return await timeTracker('Request Post File ($url)', () async {
          final send = await requestfile(newConfig, onProgress: onProgress);
          totalDataUsed += send.request?.contentLength ?? 0;
          totalDataUsed += send.contentLength ?? 0;
          return send;
        }, config: config) as Response?;
      } else {
        if (config.file != null) {
          final newConfig = config;
          newConfig.baseUrl = config.baseUrl! + url;

          return await timeTracker('Request Post File ($url)', () async {
            final send = await requestfile(newConfig, onProgress: onProgress);
            totalDataUsed += send.request?.contentLength ?? 0;
            totalDataUsed += send.contentLength ?? 0;
            return send;
          }, config: config) as Response?;
        } else {
          return await timeTracker('Request Post  ($url)', () async {
            Response? send;

            if (_multithread) {
              send = await RequestIsolate.getRequest(RequestIsolate(openAllSecurity: _openAllSecurityForMultiThread, url: Uri.parse(config.baseUrl! + url), body: body, headers: config.header, type: Api.post));
            } else {
              send = await post(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
            }
            totalDataUsed += send.request?.contentLength ?? 0;
            totalDataUsed += send.contentLength ?? 0;
            return send;
          }, config: config) as Response?;
        }
      }
    } else if (type == Api.get) {
      return await timeTracker('Request Get  ($url)', () async {
        if (onProgress != null) {
          return getProgress(
            baseUrl: config.baseUrl,
            body: body,
            config: config,
            url: url,
            onProgress: (start, end) {
              onProgress(start, end);
            },
          );
        } else {
          Response? send;
          if (_multithread) {
            send = await RequestIsolate.getRequest(RequestIsolate(openAllSecurity: _openAllSecurityForMultiThread, url: Uri.parse(config.baseUrl! + url + (body ?? '')), headers: config.header, type: Api.get));
          } else {
            send = await get(Uri.parse(config.baseUrl! + url + (body ?? '')), headers: config.header!);
          }
          totalDataUsed += send.request?.contentLength ?? 0;
          totalDataUsed += send.contentLength ?? 0;
          return send;
        }
      }, config: config) as Response?;
    } else if (type == Api.put) {
      return await timeTracker('Request Put  ($url)', () async {
        Response? send;
        if (_multithread) {
          send = await RequestIsolate.getRequest(RequestIsolate(openAllSecurity: _openAllSecurityForMultiThread, url: Uri.parse(config.baseUrl! + url), body: body, headers: config.header, type: Api.put));
        } else {
          send = await put(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
        }
        totalDataUsed += send.request?.contentLength ?? 0;
        totalDataUsed += send.contentLength ?? 0;
        return send;
      }, config: config) as Response?;
    } else if (type == Api.delete) {
      return await timeTracker('Request Delete  ($url)', () async {
        Response? send;
        if (_multithread) {
          send = await RequestIsolate.getRequest(RequestIsolate(openAllSecurity: _openAllSecurityForMultiThread, url: Uri.parse(config.baseUrl! + url), body: body, headers: config.header, type: Api.delete));
        } else {
          send = await delete(Uri.parse(config.baseUrl! + url), body: body, headers: config.header!);
        }

        totalDataUsed += send.request?.contentLength ?? 0;
        totalDataUsed += send.contentLength ?? 0;
        return send;
      }, config: config) as Response?;
    } else if (type == Api.download) {
      int? lastDownloaded;
      if (download != null) {
        if (_downloadProcess.length >= _maxDownload) {
          _downloadController.add(
            DownloadQueue(
              download,
              type: type,
              download: download,
              onProgress: onProgress,
              url: url,
            ),
          );
        } else {
          final getId = DownloadAdd(
            download,
            type: type,
            download: download,
            onProgress: onProgress,
            url: url,
          );
          _downloadController.add(getId);
          final req = HttpClient();
          final file = File((download.path![download.path!.length - 1] == '/' ? download.path! : download.path! + '/') + (download.nameFile ?? url.toString().split('/').last));
          int fileSize = 0;
          if (file.existsSync()) {
            try {
              fileSize = (await file.readAsBytes()).lengthInBytes;
            } catch (_) {
              internalHandlingData(_.toString(), debug: kReleaseMode);
            }
          } else {
            try {
              await file.create(recursive: true);
            } catch (_) {
              internalHandlingData(_.toString(), debug: kReleaseMode);
            }
          }
          req.getUrl(Uri.parse(url)).asStream().listen((event) {
            if (download.header != null) {
              download.header!.forEach((key, value) {
                event.headers.add(key, value);
              });
            }
            event.close().asStream().listen((event2) async {
              if (event2.statusCode == 200) {
                if (!(event2.contentLength == fileSize)) {
                  final output = await consolidateHttpClientResponseBytes(
                    event2,
                    onBytesReceived: (downloaded, total) {
                      totalDataUsed += (downloaded - (lastDownloaded ?? 0));
                      lastDownloaded = downloaded;
                      if (onProgress != null) {
                        onProgress(downloaded, (total ?? -1));
                      }
                    },
                  );
                  try {
                    await file.writeAsBytes(output);
                    _downloadController.add(DownloadDone(getId.id));
                    if (download.onSuccess != null) {
                      download.onSuccess!(RequestApiHelperDownloader(url: url, name: download.nameFile ?? file.path.split('/').last, path: file.path));
                    }
                  } catch (_) {
                    internalHandlingData(_.toString(), debug: kReleaseMode);
                    _downloadController.add(DownloadDone(getId.id));
                    if (download.onError != null) {
                      download.onError!(Response(json.encode({'message': _.toString()}), 666));
                    }
                  }
                } else {
                  if (download.onSuccess != null) {
                    _downloadController.add(DownloadDone(getId.id));
                    download.onSuccess!(RequestApiHelperDownloader(url: url, name: download.nameFile ?? file.path.split('/').last, path: file.path));
                  }
                }
              } else {
                if (fileSize > 0) {
                  if (download.onSuccess != null) {
                    _downloadController.add(DownloadDone(getId.id));
                    download.onSuccess!(RequestApiHelperDownloader(url: url, name: download.nameFile ?? file.path.split('/').last, path: file.path));
                  }
                } else {
                  if (download.onError != null) {
                    _downloadController.add(DownloadDone(getId.id));
                    download.onError!(Response('error', event2.statusCode));
                  }
                }
              }
            });
          });
        }
      } else {
        print('error');
      }
    }
    return null;
  }
}
