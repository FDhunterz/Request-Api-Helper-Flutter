///
/// used for main request function
///
///     import 'package:request_api_helper/request.dart' as req;
///     import 'package:request_api_helper/request_api_helper.dart' show RESTAPI, RequestApiHelperConfigData, RequestData;
///
///     other() async {
///       await req.send(
///         name: 'get/data',
///         type: RESTAPI.POST,
///         data: RequestData(),
///         changeConfig: RequestApiHelperConfigData(
///           logResponse: true,
///           onSucces: (data){
///
///           }
///         ),
///       )
///     }
///

import 'package:request_api_helper/model/config_model.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:request_api_helper/rest_api.dart' show OnUploadProgressCallback;
import 'base_request.dart';

Future send({CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigData? changeConfig, BuildContext? context, required RESTAPI type, bool? singleContext, OnUploadProgressCallback? onUploadProgress}) => _withClient(customData, data, name, changeConfig, context, type, singleContext, onUploadProgress);

Future<T> _withClient<T>(CustomRequestData? customData, RequestData? data, String? name, RequestApiHelperConfigData? changeConfig, BuildContext? context, type, singleContext, OnUploadProgressCallback? onUploadProgress) async {
  var client = BaseRequests(changeConfig: changeConfig, context: context, customData: customData, data: data, name: name, type: type, singleContext: singleContext, onUploadProgress: onUploadProgress);

  return await client.api();
}
