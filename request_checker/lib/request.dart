import 'package:request_checker/model/config_model.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:request_checker/rest_api.dart' show OnUploadProgressCallback;
import 'base_request.dart';

Future send({CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigData? changeConfig, BuildContext? context, required RESTAPI type, bool? singleContext, OnUploadProgressCallback? onUploadProgress}) => _withClient(customData, data, name, changeConfig, context, type, singleContext, onUploadProgress);

Future<T> _withClient<T>(CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigData? changeConfig, BuildContext? context, type, singleContext, OnUploadProgressCallback? onUploadProgress) async {
  var client = BaseRequests(changeConfig: changeConfig, context: context, customData: customData, data: data, name: name, type: type, singleContext: singleContext, onUploadProgress: onUploadProgress);

  return await client.api();
}
