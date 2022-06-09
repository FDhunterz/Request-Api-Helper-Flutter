import 'package:request_api_helper/request_api_helper.dart';

Api restApiParse(api) {
  if (api == 'get') {
    return Api.get;
  } else if (api == 'post') {
    return Api.post;
  } else if (api == 'put') {
    return Api.put;
  } else if (api == 'delete') {
    return Api.delete;
  } else {
    return Api.get;
  }
}
