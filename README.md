# Request Api Helper

Post, Get, Save, Helper for Flutter;

## New Updates
```dart
  Post {
    ...
    ...
    ...
    file : file, // String path of file
    fileRequestName : 'images' // request name of file
  }.request()
```

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

## 1 . Setting Env
use static Env in main like this (Release):

```dart
// == 200 response dynamic
// != 200 response {'statusCode' : other int code}

void main(
  Env(
    confurl: 'http://rootUrl/api/',
    confnoapiurl: 'http://rootUrl/'
  ).save();
  runApp(MyApp());
}

```

or use Server Switcher (Team Developing)

```dart

ServerSwitcher(
 servers: [
   {'name' : 'Server 1' , 'id' : 'http://rootUrl/'},
   {'name' : 'Server 2' , 'id' : 'http://rootUrl2/'},
 ]
)

```

## 2 . Make Login And Saving Token
First you must make login request.

```dart
login() async {
======================= GET DATA FROM SERVER

// == 200 response dynamic
// != 200 response {'statusCode' : other int code}
dynamic response = await Post( 
 name: 'login', // full url http://rootUrl/api/login
 exception : true, // error exception, false to hide
 successMessage : 'default',
 errorMessage : 'Try Again!',
 logResponse : false, // showing server response
 timeout : true, // if timeout true .request(context)
).request(context); 

// note : 

// successMessage : 'default' auto show message from server [200]
// { 'message' : 'Thanks For Buy' }

// errorMessage : 'default' auto show message from server [!=200]
// { 'message' : 'Error You Must Login' }

// timeout : CustomTimeout() // for routing to your custom view

======================= Process Data
// ex : response is 
// {'token' : 'mytoken' , 'user' : {'name' : 'MIAUW' , 'id' : 1}}

if(response != null){
  if(response['statusCode'] == null){

    // important
    await Session().save('access_token', response['token']);
    await Session().save('token_type', 'Bearer');

    // auto save different type data
    await Session().save('user_name',response['user']['name']);
    await Session().save('user_id',response['user']['id']);
  }
}

}
```

## 3 . Use Post / Get After Saving Token

Post

```dart
Map<String,dynamic> mydata = await Post( 
 name: 'data/employee', // full url http://rootUrl/api/data/employee
 exception : true,
 logResponse : true,
 timeout : true, 
).request(context); 

if(mydata != null){
 if(mydata['statusCode'] == null){
  // success return
 }{
  // error return
 }
 // no response
}

```

Get

```dart
Map<String,dynamic> mydata = await Get( 
 name: 'data/employee', // full url http://rootUrl/api/data/employee
 exception : true,
 logResponse : true,
 timeout : true, 
 customRequest : '?mydata=$yourdata',
).request(context); 

if(mydata != null){
 if(mydata['statusCode'] == null){
  // success return
 }{
  // error return
 }
 // no response
}

```

## 4 . Use Post / Get other Url?


```dart
Map<String,dynamic> mydata = await Post( 
 name: 'image/myimage', // full url http://google.com/api/image/myimage
 customUrl : 'http://google.com/api/',
 customHeader : {
   'your header' : 'this header',
 },
 body : {
   'mybody' : 'myvalue',
 }
 exception : true,
 logResponse : true,
 timeout : true, 
).request(context); 
```

## 4 . What is Session?

session is Shared preferences plugin, implement :

save to Shared Preferences
```dart
await Session().save('myname','MIAUW'); // String
await Session().save('myint',100); // int
await Session().save('mybool',false); // bool

```

load from Shared Preferences
```dart
String mystring = await Session().load('myname'); // String
int myint = await Session().load('myint'); // int
bool mybool = await Session().load('mybool'); // bool
