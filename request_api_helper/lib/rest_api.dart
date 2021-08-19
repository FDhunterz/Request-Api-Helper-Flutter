import 'dart:convert';

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

BuildContext? _currentContext;

dynamic _response;
String _request = '?';
Map<String, dynamic>? _body;
bool _isFile = false;

abstract class RestApi {
  BuildContext? context;
  bool? singleContext;

  resetVariable() {
    _response = null;
    _request = '?';
  }

  RestApi({this.context, this.singleContext});

  process({RequestData? data, CustomRequestData? customData, Map<String, String>? header, RequestApiHelperConfigModel? config, String? name, required RESTAPI type}) async {
    await resetVariable();
    if (_currentContext != context || singleContext == true) {
      _currentContext = context;
    }
    if (config!.version != null) {
      _request += 'version=${config.version}';
    }
    await bodyCheck(data, config, type);

    await requestApi(data, customData, header, config, name, type);

    await responseApi(config, type);
  }

  bodyCheck(RequestData? data, RequestApiHelperConfigModel config, RESTAPI type) {
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

  requestApi(RequestData? data, CustomRequestData? customData, header, RequestApiHelperConfigModel config, name, RESTAPI type) async {
    Map<String, String> _header = header;
    List<String> _file = [];
    List<String> _requestNameFile = [];
    Uri _http = Uri.parse('');
    _isFile = false;
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
        _http = Uri.parse(config.url! + name! + (type != RESTAPI.POST ? _request : ''));
      }
    }

    if (type == RESTAPI.GET) {
      _response = await http.get(_http, headers: _header).timeout(config.timeout ?? Duration(milliseconds: 10000));
    } else if (type == RESTAPI.POST) {
      if (_file.length > 0) {
        var request = http.MultipartRequest('POST', _http);
        request.headers.addAll(_header);
        if (config.version != null) {
          request.fields['version'] = config.version!;
        }

        if (_body != null) {
          if (_body is Map) {
            _body!.forEach((k, v) {
              request.fields[k] = v;
            });
          }
        }

        for (int counterfile = 0; counterfile < _file.length; counterfile++) {
          request.files.add(await http.MultipartFile.fromPath(_requestNameFile[counterfile], _file[counterfile], contentType: MediaType('application', _file[counterfile].split('.').last)));
        }

        _response = await request.send().timeout(config.timeout ?? Duration(milliseconds: 120000));
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

  responseApi(RequestApiHelperConfigModel config, RESTAPI type) async {
    if (config.onComplete != null) {
      await config.onComplete;
    } else {
      dynamic dataresponse;
      dynamic _responses = _isFile ? await _response.stream.bytesToString() : _response.body;
      if (_response.statusCode != 200 || _response.statusCode != 201 || _response.statusCode != 202) {
        print(errorList(_response.statusCode));
        print(_responses);
      }

      if (_response.statusCode == 200 || _response.statusCode == 201 || _response.statusCode == 202) {
        dataresponse = json.decode(_responses);
        if (config.logResponse == true) {
          await Response.start(dataresponse);
        }
        if (config.successMessage == 'default') {
          Fluttertoast.showToast(msg: dataresponse['message']);
        } else if (config.successMessage != null && config.successMessage != '') {
          Fluttertoast.showToast(msg: config.successMessage!);
        }

        if (config.onSuccess != null) {
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
          return dataresponse;
        }
      } else {
        if (_response.statusCode == 401) {
          if (config.authErrorRedirect != null) {
            if (_currentContext != context || singleContext == true) {
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
          return config.onError!(_response.statusCode, dataresponse);
        } else {
          print('Failed, Code ${_response.statusCode}');
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
          return {'statusCode': _response.statusCode};
        }
      }
    }
  }
}
