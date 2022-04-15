# Request Api Helper

one code, one style for all restapi;


## Installation

Add this to your package's pubspec.yaml file:

```bash
dependencies:
  request_api_helper:
```

## Usage

```dart
import 'package:request_api_helper/request_api_helper.dart';
```

## 1 . Setting Config
use static Env in main like this (Release):

```dart
import 'package:request_api_helper/request_api_helper.dart';
import 'package:request_api_helper/module/request.dart';

void main(
  WidgetsFlutterBinding.ensureInitialized();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RequestApiHelper.init(
    RequestApiHelperData(baseUrl: 'https://your-base-url.com/api/', debug: true, navigatorKey: navigatorKey),
  );
  runApp(MyApp(
    navigatorKey: navigatorKey,
  ));
}

// must add navigator key in your widget in runApp()
class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

```

## 2 . Make Login And Saving Token
First you must make login request.

```dart
login() async {
  final getResponse = await RequestApiHelper.sendRequest(
        url: 'v1/login',
        type: Api.post,
        replacementId: 1, // replace same function when triggered
        runInBackground: true, // if change screen, http not be canceled
        config: RequestApiHelperData(
          body: {"nomor": "088217081355", "device_name": "Iphone 13 Pro Max"},
          bodyIsJson: true,
          onSuccess: (data) {
            Session.save(header: 'token', stringData: 'Bearer ${data['token']}');
            setState(() {});
          },
        ),
      );
}
```

other request, send full config in config 
```dart
login() async {
  final getResponse = await RequestApiHelper.sendRequest(
        url: 'v1/login',
        type: Api.post,
        replacementId: 1, // replace same function when triggered
        runInBackground: true, // if change screen, http not be canceled
        config: RequestApiHelperData(
          baseUrl: 'your-custom-domain',
          header: {
            'custom' : 'header',
          },
          body: {"nomor": "088217081355", "device_name": "Iphone 13 Pro Max"},
          bodyIsJson: true,
          onSuccess: (data) {
            Session.save(header: 'token', stringData: 'Bearer ${data['token']}');
            setState(() {});
          },
        ),
      );
}
```

## 3 . What is Session?

session is Shared preferences plugin, implement :

save to Shared Preferences
```dart
await Session.save('myname','MIAUW'); // String
await Session.save('myint',100); // int
await Session.save('mybool',false); // bool

```

load from Shared Preferences
```dart
String mystring = await Session.load('myname'); // String
int myint = await Session.load('myint'); // int
bool mybool = await Session.load('mybool'); // bool

```