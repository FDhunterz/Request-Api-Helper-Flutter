import 'package:flutter/material.dart';
import 'package:request_checker/request.dart';
import 'package:request_checker/request_api_helper.dart';
import 'package:request_checker/session.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RequestApiHelper.init(
    RequestApiHelperData(navigatorKey: navigatorKey, baseUrl: 'https://app.mediplusindonesia.co.id/api/', debug: true),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silver VTR',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: MyHomePage(),
      navigatorKey: navigatorKey,
      // navigatorObservers: [RequestApiHelperObserver()],
      // home: Topup(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getData() async {
    RequestApiHelper.sendRequest(type: Api.post, url: 'v1/doctors/login');
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold();
        });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async {
      await Session.init();
      print(await Session.load('testing'));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
      ),
    );
  }
}
