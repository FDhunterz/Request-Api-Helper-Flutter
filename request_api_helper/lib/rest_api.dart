/// core of process request

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:request_api_helper/model/config_model.dart';
import 'package:request_api_helper/response.dart';
import 'package:request_api_helper/session.dart';
import 'package:flutter/material.dart' show MaterialPageRoute;

import 'background.dart';
import 'model/error_list.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

/// get request parser
String _request = '?';

/// body
Map<String, dynamic>? _body;

/// is file included
bool _isFile = false;

abstract class RestApi {
  BuildContext? context;
  bool? singleContext;
  dynamic _response;
  bool ifResponseError = false;
  static bool trustSelfSigned = true;

  resetVariable() {
    _response = null;
    _request = '?';
  }

  RestApi({this.context, this.singleContext});

  process({RequestData? data, CustomRequestData? customData, Map<String, String>? header, RequestApiHelperConfigData? config, String? name, required RESTAPI type, OnUploadProgressCallback? onUploadProgress}) async {
    await resetVariable();
    ifResponseError = false;
    if (config!.version != null) {
      _request += 'version=${config.version}';
    }
    await bodyCheck(data, config, type);

    await requestApi(data, customData, header, config, name, type, onUploadProgress);

    await responseApi(config, type, onUploadProgress);
    return ifResponseError;
  }

  bodyCheck(RequestData? data, RequestApiHelperConfigData config, RESTAPI type) {
    if (type == RESTAPI.GET) {
      if (data!.body != null) {
        if (data.body is Map) {
          int _counter = 0;
          data.body!.forEach((key, value) {
            ++_counter;
            if (!(_counter == data.body!.length)) {
              _request += (config.version != null ? '&' : '') + '$key=$value&';
            } else {
              _request += '$key=$value';
            }
          });
        }
      }
    }
    // else if (type == RESTAPI.POST) {}
  }

  static HttpClient getHttpClient({Duration? duration}) {
    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = duration ?? const Duration(seconds: 120)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  void _checkingLoadingSession(config) {
    if (config.withLoading != null) {
      if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
        if (context == null) {
          print('REQUIRED! context parameter in .request(context)');
        } else {
          isLoading = false;
          Navigator.pop(context!);
          ifResponseError = true;
        }
      }
    }
  }

  requestApi(RequestData? data, CustomRequestData? customData, header, RequestApiHelperConfigData config, name, RESTAPI type, OnUploadProgressCallback? onUploadProgress) async {
    Map<String, String> _header = header;
    List<String> _file = [];
    List<String> _requestNameFile = [];
    Uri _http = Uri.parse('');
    _isFile = false;
    _body = {};
    if (customData != null) {
      if (customData.file != null) {
        _file = customData.file!.filePath;
        _requestNameFile = customData.file!.fileRequestName;
        _isFile = true;
      }
      if (customData.url != null) {
        _header = customData.header!;
        _body = customData.body;
        _http = Uri.parse(customData.url!);
      }
    } else {
      if (data != null) {
        if (data.file != null) {
          _file = data.file!.filePath;
          _requestNameFile = data.file!.fileRequestName;
          _isFile = true;
        }
        _body = data.body;
      }
      _http = Uri.parse(config.url! + name! + (type != RESTAPI.POST ? _request : ''));
      if (_body == null) _body = {};
    }
    if (config.version != null) {
      _body!.addAll({'version': config.version});
    }

    if (type == RESTAPI.GET) {
      _response = await http.get(_http, headers: _header).timeout(config.timeout ?? Duration(milliseconds: 10000));
    } else if (type == RESTAPI.POST) {
      if (_file.length > 0) {
        final httpClients = getHttpClient(
          duration: config.timeout,
        );
        final requests = await httpClients.postUrl(_http);
        int byteCount = 0;

        var request = http.MultipartRequest("POST", _http);

        if (config.version != null) {
          request.fields['version'] = config.version!;
        }

        if (_body != null) {
          if (_body is Map) {
            _body!.forEach((k, v) {
              if (k != 'version') {
                request.fields[k] = v;
              }
            });
          }
        }

        for (int counterfile = 0; counterfile < _file.length; counterfile++) {
          if (_file[counterfile] == '' || _file[counterfile] == 'null') {
            request.fields['${_requestNameFile[counterfile]}'] = 'null';
          } else {
            request.files.add(await http.MultipartFile.fromPath(_requestNameFile[counterfile], _file[counterfile], contentType: MediaType('application', _file[counterfile].split('.').last)));
          }
        }

        Stream<List<int>>? streamUpload;
        request.headers.addAll(_header);

        if (onUploadProgress != null) {
          var msStream = request.finalize();
          var totalByteLength = request.contentLength;
          String decodes = request.headers[HttpHeaders.contentTypeHeader] ?? '';
          requests.headers.add(HttpHeaders.authorizationHeader, {request.headers[HttpHeaders.authorizationHeader]});
          requests.headers.set(HttpHeaders.contentTypeHeader, {decodes});

          streamUpload = msStream.transform(
            new StreamTransformer.fromHandlers(
              handleData: (data, sink) {
                sink.add(data);

                byteCount += data.length;

                onUploadProgress(byteCount, totalByteLength);
              },
              handleError: (error, stack, sink) {
                throw error;
              },
              handleDone: (sink) {
                sink.close();
                // UPLOAD DONE;
              },
            ),
          );
        }

        if (streamUpload != null) {
          await requests.addStream(streamUpload);

          _response = await requests.close();
        } else {
          _response = await request.send().timeout(config.timeout ?? Duration(milliseconds: 120000));
        }
      } else {
        _response = await http.post(_http, body: _body, headers: _header).timeout(config.timeout ?? Duration(milliseconds: 120000));
      }
    } else if (type == RESTAPI.PUT) {
      _response = await http.put(_http, headers: _header, body: _body).timeout(config.timeout ?? Duration(milliseconds: 10000));
    } else if (type == RESTAPI.DELETE) {
      _response = await http.delete(_http, headers: _header, body: _body).timeout(config.timeout ?? Duration(milliseconds: 10000));
    } else if (type == RESTAPI.PATCH) {
      _response = await http.patch(_http, headers: _header, body: _body).timeout(config.timeout ?? Duration(milliseconds: 10000));
    }
  }

  responseApi(RequestApiHelperConfigData config, RESTAPI type, OnUploadProgressCallback? onUploadProgressCallback) async {
    try {
      if (config.onCompleteRawRespose != null) {
        return config.onCompleteRawRespose!(_response);
      } else {
        var dataresponse;
        int statusCode = 500;
        var _responses;
        if (onUploadProgressCallback != null) {
          _responses = await readResponseAsString(_response);
          final HttpClientResponse res = await _response;
          statusCode = res.statusCode;
        } else {
          _responses = _isFile ? await _response.stream.bytesToString() : _response.body;
          statusCode = _response.statusCode;
        }

        try {
          dataresponse = json.decode(_responses);
        } catch (e) {
          print(errorList(statusCode));
          print(_responses);
          if (config.withLoading != null) {
            if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
              if (context == null) {
                print('REQUIRED! context parameter in .request(context)');
              } else {
                ifResponseError = true;
                isLoading = false;
                Navigator.pop(context!);
              }
            }
          }
          return;
        }

        if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
          if (config.logResponse == true) {
            await Response.start(dataresponse);
          }
          if (config.successMessage == 'default') {
            Fluttertoast.showToast(msg: dataresponse['message']);
          } else if (config.successMessage != null && config.successMessage != '') {
            Fluttertoast.showToast(msg: config.successMessage!);
          }

          if (config.onSuccess != null) {
            _checkingLoadingSession(config);
            return config.onSuccess!(dataresponse);
          } else {
            if (config.withLoading != null) {
              if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
                if (context == null) {
                  print('REQUIRED! context parameter in .request(context)');
                } else {
                  isLoading = false;
                  Navigator.pop(context!);
                }
              }
            }
            _checkingLoadingSession(config);
            return dataresponse;
          }
        } else {
          if (config.logResponse == true) {
            await Response.start(dataresponse);
          }
          if (statusCode == 401) {
            if (config.authErrorRedirect != null) {
              if (currentContext != context || singleContext == true) {
                if (context != null) {
                  Session.clear();
                  return Navigator.pushAndRemoveUntil(
                      context!,
                      MaterialPageRoute(
                        builder: (context) => config.authErrorRedirect!.widget!,
                      ),
                      (Route<dynamic> route) => false);
                } else {
                  print('REQUIRED! context parameter in .request(context)');
                }
              }
            }
          }
          if (config.errorMessage == 'default') {
            Fluttertoast.showToast(msg: dataresponse['message']);
          } else if (config.errorMessage != null && config.errorMessage != '') {
            Fluttertoast.showToast(msg: config.errorMessage!);
          }

          if (config.onError != null) {
            _checkingLoadingSession(config);
            return config.onError!(statusCode, dataresponse);
          } else {
            print('Failed, Code $statusCode');
            _checkingLoadingSession(config);
            return {'statusCode': statusCode};
          }
        }
      }
    } catch (_) {
      print(_.toString());
    }
  }
}
