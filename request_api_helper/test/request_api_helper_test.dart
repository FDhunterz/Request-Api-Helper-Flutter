import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:request_api_helper/request_api_helper.dart';

void main(context) {
  Env(
    confurl: 'https://scool.alamraya.site/api/',
    confnoapiurl:  'https://scool.alamraya.site/',
  ).save();
  test('adds one to input values', () async {
    dynamic response = await Post(
      name: 'launcher/list',
      exception: true,
      beforeSend: ()=> print('a'),
      onTimeout: ()=> print('timeout loh'),
      onSocket: ()=> print('internet tidak tersambung'),
      onException: (val)=> print(val),
      
      body: {
        'lol' : 'a',
        'anjit' : 'anjim'
      }
      // timeout: 3000,
    ).request(context);

    print(response);
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