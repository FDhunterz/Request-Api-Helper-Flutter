import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' show BuildContext, Navigator, MaterialPageRoute;
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:request_checker/model/config_model.dart';
import 'package:request_checker/rest_api.dart';
import 'package:request_checker/session.dart';
import 'package:request_checker/timeout.dart';

import 'background.dart';

class BaseRequests extends RestApi {
  RequestData? data;
  CustomRequestData? customData;
  String? name;
  RequestApiHelperConfigData? changeConfig;
  RESTAPI type;
  BuildContext? context;
  bool? singleContext;
  OnUploadProgressCallback? onUploadProgress;

  BaseRequests({this.customData, this.data, this.name, this.changeConfig, this.context, required this.type, this.singleContext = false, this.onUploadProgress}) : super(singleContext: singleContext, context: context);

  Future api() async {
    await send();
  }

  send() async {
    final RequestApiHelperConfigData config = RequestApiHelperConfig.load(
      config: changeConfig,
    );

    Map<String, String> _header;
    if (config.withLoading != null) {
      if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
        if (context != null) {
          isLoading = true;
          BackDark(view: config.withLoading).dialog(context);
        }
      }
    }
    bool ifResponseError = false;
    try {
      if (config.beforeSend != null) {
        await config.beforeSend!;
      }
      String? token = await Session.load('token');

      // input header
      if (token != null && token != '') {
        _header = {
          'Accept': 'application/json',
          'Authorization': token,
        };
      } else {
        _header = {
          'Accept': 'application/json',
        };
      }
      ifResponseError = await process(config: config, data: customData == null ? ((data == null) ? RequestData() : data) : null, header: _header, customData: customData, name: name, type: type, onUploadProgress: onUploadProgress);
      if (context != null) {
        currentContext = context;
      }
    } on SocketException catch (se) {
      if (config.withLoading != null && ifResponseError == false) {
        if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
          if (context != null) {
            isLoading = false;
            Navigator.pop(context!);
          }
        }
      }
      if (config.socketMessage != null) {
        Fluttertoast.showToast(msg: config.socketMessage!);
      }
      if (context != null) {
        currentContext = context;
      }
      if (config.onSocket != null) {
        return config.onSocket!(se);
      }
      if (config.socketMessage != null) {
        if (context != null) {
          if (currentContext != context || singleContext == true) {
            if (config.socketRedirect != null) {
              if (config.socketRedirect!.widget != null) {
                Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => config.socketRedirect!.widget!,
                  ),
                );
              } else if (config.socketRedirect!.toogle == true) {
                Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => Timeout(),
                  ),
                );
              }
            }
          }
        }
      }
    } on TimeoutException catch (te) {
      if (config.withLoading != null && ifResponseError == false) {
        if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
          if (context != null) {
            isLoading = false;
            Navigator.pop(context!);
          }
        }
      }
      if (config.timeoutMessage != null) {
        Fluttertoast.showToast(msg: config.timeoutMessage!);
      }
      if (context != null) {
        currentContext = context;
      }
      if (config.onTimeout != null) {
        return config.onTimeout!(te);
      }
      if (config.timeoutMessage != null) {
        if (context != null) {
          if (currentContext != context || singleContext == true) {
            if (config.timeoutRedirect != null) {
              if (config.timeoutRedirect!.widget != null) {
                Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => config.timeoutRedirect!.widget!,
                  ),
                );
              } else if (config.timeoutRedirect!.toogle == true) {
                Navigator.push(
                  context!,
                  MaterialPageRoute(
                    builder: (context) => Timeout(),
                  ),
                );
              }
            }
          }
        }
      }
    } catch (e) {
      if (config.withLoading != null && ifResponseError == false) {
        if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
          if (context != null) {
            isLoading = false;
            Navigator.pop(context!);
          }
        }
      }
      if (context != null) {
        currentContext = context;
      }
      if (config.onException != null) {
        await config.onException!(e);
      } else {
        print(e.toString());
      }
    }
  }
}
