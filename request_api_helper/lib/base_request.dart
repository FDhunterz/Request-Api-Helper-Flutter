import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' show BuildContext, Navigator, MaterialPageRoute;
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:request_api_helper/model/config_model.dart';
import 'package:request_api_helper/rest_api.dart';
import 'package:request_api_helper/session.dart';
import 'package:request_api_helper/timeout.dart';

import 'background.dart';

class BaseRequests extends RestApi {
  RequestData? data;
  CustomRequestData? customData;
  String? name;
  RequestApiHelperConfigModel? changeConfig;
  RESTAPI type;
  BuildContext? context;

  BaseRequests({this.customData, this.data, this.name, this.changeConfig, this.context, required this.type});

  Future api() async {
    await send();
  }

  send() async {
    final RequestApiHelperConfigModel config = RequestApiHelperConfig.load(
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
    try {
      if (config.beforeSend != null) {
        await config.beforeSend!;
      }
      String? token = await Session.load('token');
      if (currentContext != context || singleContext == true) {
        currentContext = context;
      }

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
      await process(
        config: config,
        data: data,
        header: _header,
        customData: customData,
        name: name,
        type: type,
      );
    } on SocketException catch (se) {
      if (config.withLoading != null) {
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
      if (config.withLoading != null) {
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
      if (config.withLoading != null) {
        if (config.withLoading!.widget != null || config.withLoading!.toogle == true) {
          if (context != null) {
            isLoading = false;
            Navigator.pop(context!);
          }
        }
      }
      if (config.onException != null) {
        await config.onException!(e);
      } else {
        print(e.toString());
      }
    }
  }
}
