# Request Api Helper

Post, Get, Save, Helper for Flutter;


## Installation

Add this to your package's pubspec.yaml file:

```bash
dependencies:
  request_api_helper:
```

## Usage

```dart
import 'package:request_api_helper/request.dart' as req;
```

## 1 . Setting Config
use static Env in main like this (Release):

```dart
import 'package:request_api_helper/model/config_model.dart';

void main(
  RequestApiHelperConfig.save(
    RequestApiHelperConfigData(
      url: 'https://official-joke-api.appspot.com/',
      noapiurl: 'https://official-joke-api.appspot.com/',
      logResponse: true,
      withLoading: Redirects(toogle: false),
    ),
  );
  runApp(MyApp());
}

```

## 2 . Make Login And Saving Token
First you must make login request.

```dart
login() async {
======================= GET DATA FROM SERVER
  await req.send(
    name: 'login',
    type: RESTAPI.POST,
    data: RequestData(
      body: {
        'username' : username,
        'password' : password,
      }
    ),
    RequestApiHelperConfigData(
      onSuccess: (response) async {
        // important
        await Session.save('token', 'Bearer ' + response['token']);

        // auto save different type data
        await Session.save('user_name', response['user']['name']);
        await Session.save('user_id', response['user']['id']);
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
