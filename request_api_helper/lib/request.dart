import 'package:request_api_helper/model/config_model.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'base_request.dart';

Future send({CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigModel? changeConfig, BuildContext? context, required RESTAPI type}) => _withClient(customData, data, name, changeConfig, context, type);

Future<T> _withClient<T>(CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigModel? changeConfig, BuildContext? context, type) async {
  var client = BaseRequests(
    changeConfig: changeConfig,
    context: context,
    customData: customData,
    data: data,
    name: name,
    type: type,
  );

  return await client.api();
}
