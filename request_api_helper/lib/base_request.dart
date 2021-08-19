import 'package:flutter/material.dart' show BuildContext, Navigator;
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:request_api_helper/model/config_model.dart';
import 'package:request_api_helper/rest_api.dart';
import 'package:request_api_helper/session.dart';

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
        await config.onException!(e.toString());
      } else {
        print(e.toString());
      }
    }
  }
}
