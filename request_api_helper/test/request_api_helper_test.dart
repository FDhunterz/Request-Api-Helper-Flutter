import 'package:flutter_test/flutter_test.dart';
import 'package:request_api_helper/model/config_model.dart';
import 'package:request_api_helper/model/redirect_helper.dart';
import 'package:request_api_helper/request.dart' as req;
// import 'package:request_api_helper/request_api_helper.dart';

void main() {
  test('adds one to input values', () async {
    await RequestApiHelperConfig.save(
      RequestApiHelperConfigModel(
        url: 'https://official-joke-api.appspot.com/',
        noapiurl: 'https://official-joke-api.appspot.com/',
        logResponse: true,
        withLoading: Redirects(toogle: false),
      ),
    );

    await req.send(name: 'jokes/programming/random', data: RequestData(), type: RESTAPI.PATCH, changeConfig: RequestApiHelperConfigModel(onSuccess: (data) {}));
  });
  // print('a');
}
