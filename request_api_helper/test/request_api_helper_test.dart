import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:request_api_helper/request_api_helper.dart';

void main() {
  test('adds one to input values', () async {
    Env(
      confurl: 'https://url/api/',
      confnoapiurl:  'https://url/',
      confclientId: '',
      confclientsecret: '',
      confgrantType: 'password',
    ).save();

    await Auth(username: 'developer',password: '123456',exception: true).login();

    await Post(name: 'test/list', logResponse: true,exception: true).request();
  });
}

class Myapps extends StatefulWidget{
  @override
  _Myapps createState()=> _Myapps();
}

class _Myapps extends State<Myapps>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Text('lol')
      ),
    );
  }
}
