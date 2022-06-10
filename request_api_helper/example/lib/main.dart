import 'package:example/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:request_api_helper/loading.dart';
import 'package:request_api_helper/request_api_helper.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  // in main.dart after WidgetsFlutterBinding.ensureInitialized()
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
    Loading.currentContext = context;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [RequestApiHelperObserver()],
      title: 'Request Api Helper',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText2: GoogleFonts.karla(textStyle: textTheme.bodyText2).apply(color: Colors.white),
        ),
      ),
      home: const StartView(),
    );
  }
}
