import 'package:example/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:request_api_helper/loading.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

void main() async {
  // in main.dart after WidgetsFlutterBinding.ensureInitialized()
  WidgetsFlutterBinding.ensureInitialized();
  await RequestApiHelper.init(
    RequestApiHelperData(
      baseUrl: '',
      debug: true,
    ),
    encryptedSession: true,
    useMultiThread: true,
  );
  Loading.widget = (context) async {
    await showDialog(
      barrierColor: Colors.black12,
      context: context,
      builder: (context) {
        Loading.currentContext = context;
        Loading.lastContext = context;
        return const Material(
          child: Center(
            child: Text('Loading'),
          ),
        );
      },
    );
    Loading.loading = false;
    Loading.currentContext = context;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestApiHelperApp(
      title: 'Request Api Helper',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const StartView(),
    );
  }
}
