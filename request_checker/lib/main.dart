import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:request_checker/request_api_helper.dart';

void main() {
  Env(
    timeout: 10,
    errorMessage: 'Hubungi Pengembang',
    successMessage: 'default',
    exception: false,
    beforeSend: ()=>print('hi this is me')
  ).saveConfiguration();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  postWithName() async {
    dynamic data = await Post(
      exception: true,
      name: 'launcher/list',
      timeoutRedirect: true,
      socketRedirect: true,
      timeout: 1000,
      onException: (v)=> print(v),
    ).request(context);

    if(data != null){
      if(data['statusCode'] == null){
        print(data);
        // no error [200]
      }else{
        // error code != [200]
      }
      // no response / exception
    }

    // this is raw 
    // await Post(
    //   exception: false,
    //   name: 'launcher/list',
    //   timeoutRedirect: true,
    //   socketRedirect: true,
    //   onException: (v)=> print(v),
    //   onComplete: (val)=> print(val),
    // ).request(context);
  }

  getWithName() async {
    dynamic data = await Get(
      exception: false,
      name: 'launcher/list',
      timeoutRedirect: true,
      socketRedirect: true,
      onException: (v)=> print(v),
    ).request(context);

    if(data != null){
      if(data['statusCode'] == null){
        // no error [200]
      }else{
        // error code != [200]
      }
      // no response / exception
    }

    // this is raw 
    // await Post(
    //   exception: false,
    //   name: 'launcher/list',
    //   timeoutRedirect: true,
    //   socketRedirect: true,
    //   onException: (v)=> print(v),
    //   onComplete: (val)=> print(val),
    // ).request(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServerSwitcher(
              servers: [
                {'name': 'my Server' , 'id' : 'http://192.168.0.117/scool/'}
              ],
            ),

            SizedBox(height:10),

            RaisedButton(
              child: Text('Post With Name'),
              onPressed: () async {
                Fluttertoast.showToast(msg:'Loading...');
                await postWithName();
              },
            ),

            SizedBox(height:10),

            RaisedButton(
              child: Text('Get With Name'),
              onPressed: () async {
                Fluttertoast.showToast(msg:'Loading...');
                await getWithName();
              },
            )
          ],
        ),
      )
    );
  }
}
