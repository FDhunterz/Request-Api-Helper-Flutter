import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'env.dart';

// core login

class Auth{
  Session session = new Session();
  /// username Login Laravel OAuth >> .login();
  final username; 
  /// password Login Laravel OAuth >> .login();
  final password;
  /// url name without root example 'get/user' >> .getUser();
  final name;
  /// use it for get session in shared_preferences, example => getData:['user_id'] >> required;
  List getData;
  /// response data from API , example => responseData:['name','u_id'].
  /// 
  /// work with responseData
  List responseData;
  /// name for save session in shared_preferences, example => responseData:['name','u_id'] .
  /// 
  /// work with nameSession
  List nameSession;
  Auth({Key key , this.nameSession, this.responseData , this.getData , this.name ,@required this.username,@required this.password});


  login() async {
   try{
    final sendlogin = await http.post(noapiurl+'oauth/token', body: {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientsecret,
        "username": username,
        "password": password,
      }, headers: {
        'Accept': 'application/json',
      });

  dynamic getresponse = json.decode(sendlogin.body);
    if(sendlogin.statusCode == 200){
      if (getresponse['error'] == 'invalid_credentials') {
          Fluttertoast.showToast(msg:getresponse['message']);
        } else if (getresponse['error'] == 'invalid_request') {
          Fluttertoast.showToast(msg:getresponse['hint']);
        } else if (getresponse['token_type'] == 'Bearer') {
          print(getresponse['access_token']);
          session.save('access_token', getresponse['access_token']);
          session.save('token_type', getresponse['token_type']);
        }
      Fluttertoast.showToast(msg:'Token saved');
      // await getUser();
      return print('success');
    }else if(sendlogin.statusCode == 401){
      Fluttertoast.showToast(msg:'Password / Username Salah');
    }else{
      Fluttertoast.showToast(msg:'Error Code ${sendlogin.statusCode}');
      return print('failure');
    }
   } on SocketException catch (_) {
      return Fluttertoast.showToast(msg:'Connection Timed Out');
    } on TimeoutException catch (_){
      return Fluttertoast.showToast(msg:'Request Timeout, try again');
    } catch (e) {
      print('error Exception');
      return print(e.toString());
    }
  }

  getUser() async {
    dynamic getresponse = await Get(name: name,customrequest: '').request();
    // print(getresponse['cm_name']);
    if(getresponse.length > 0 ){
      
      if(nameSession != null){  
        for(var i = 0; i < nameSession.length ; i++){
          if(responseData[i]){
            session.save(nameSession[i], getresponse[responseData[i]]);
          }
        }
      }
      Fluttertoast.showToast(msg:'Login Success');
    }else{
    Fluttertoast.showToast(msg:'Profile Not Found');
    }
  }

  getsession() async {
    Map <String,dynamic> result = new Map();
    if(getData != null){    
      for(var i = 0 ; i < getData.length;i++){
        result[getData[i]] = await session.load(getData[i]);
      }
    }
    return result;
  }
}

class Get{
  Session session = new Session();
  /// location : 127.0.0.1/myapps/api/['this is name']
  /// 
  /// name = store_data;
  String name;
  /// location : 127.0.0.1/myapps/api/store_data['this is custom request']
  /// 
  /// ex : customrequest : '?id=1'
  /// 
  String customrequest = '';
  /// ex full custom url : google.com/api/myapps/store_data
  /// 
  /// custom request to get data from other website or server
  /// 
  String customUrl;
  /// show error message 
  String errorMessage;
  /// show success message 
  String successMessage;
  /// show log print response 
  bool logResponse;
  Get({Key key , this.name , this.customrequest , this.customUrl, this.errorMessage,this.logResponse, this.successMessage});

  request() async {
    dynamic data;
    dynamic header;
    try{
      dynamic acc = await session.load('token_type');
      dynamic auth = await  session.load('access_token');
      String token = "$acc $auth" ;

      if(auth != null || auth != ''){
        header = {
          'Accept' : 'application/json',
          'Authorization' : token,
        };
      }else{
        header = {
          'Accept' : 'application/json',
        };
      }
      
      if(customUrl != null && customUrl != ''){
        data = await http.get(customUrl,
          headers : header
        );
      }else{
        data = await http.get(url + name + customrequest,
          headers : header
        );
      }
      dynamic dataresponse = json.decode(data.body);

      if(logResponse == true){
        print(dataresponse.toString());
      }
      
    if(data.statusCode == 200){
      if(successMessage != null && successMessage != ''){
        Fluttertoast.showToast(msg:successMessage);
      }
      return dataresponse;
    }else{
      if(errorMessage != null && errorMessage != ''){
        Fluttertoast.showToast(msg:errorMessage);
      }
      print('${data.statusCode}');
      return 'Failed, Code ${data.statusCode}';
    }

    } on SocketException catch (_) {
      Fluttertoast.showToast(msg:'Connection Timed Out',);
    } on TimeoutException catch (_){
      Fluttertoast.showToast(msg:'Request Timeout, try again',);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg:e.toString());
    }
  }
}

class Post{
  Session session = new Session();
  /// location : 127.0.0.1/myapps/api/['this is name']
  /// 
  /// name = store_data;
  String name;
  /// 'dynamic' type 
  /// 
  /// body = { 'id' : this.id , 'type' : 'owner'  }
  /// 
  dynamic body;
  /// show error message 
  String errorMessage;
  /// show success message 
  String successMessage;
  /// show log print response 
  bool logResponse;
  /// ex full custom url : google.com/api/myapps/store_data
  /// 
  /// custom request to get data from other website or server
  /// 
  String customUrl;
  /// set custom header on request format 
  /// {  properties : value , other
  /// }
  /// 
  dynamic customHeader;

  Post({Key key , this.name,this.body , this.customUrl,this.errorMessage,this.logResponse, this.successMessage , this.customHeader});
  request() async {

    dynamic data;
    dynamic header;
    try{
      dynamic acc = await session.load('token_type');
      dynamic auth = await  session.load('access_token');
      String token = "$acc $auth" ;

      if(auth != null || auth != ''){
        header = {
          'Accept' : 'application/json',
          'Authorization' : token,
        };
      }else{
        header = {
          'Accept' : 'application/json',
        };
      }

      if(customUrl != null && customUrl != ''){
        data = await http.post(customUrl,
          body : body,
          headers : customHeader,
        );
      }else{
        data = await http.post(url+name,
          body : body,
          headers : header,
        );
      }

      dynamic dataresponse = json.decode(data.body);
      if(logResponse == true){
        print(dataresponse.toString());
      }

      if(data.statusCode == 200){
        if(successMessage != null && successMessage != ''){
          Fluttertoast.showToast(msg:successMessage);
        }
      return dataresponse;
    }else{
      print('Error Code ${data.statusCode}');
      if(errorMessage != null && errorMessage != ''){
          Fluttertoast.showToast(msg:errorMessage);
      }
      return 'Failed, Code ${data.statusCode}';
    }

    } on SocketException catch (_) {
      Fluttertoast.showToast(msg:'Connection Timed Out',);
    } on TimeoutException catch (_){
      Fluttertoast.showToast(msg:'Request Timeout, try again',);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg:e.toString(),);
    }
  }
}