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
    final sendlogin = await http.post(noapiurl+'auth', body: {
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
          session.saveString('access_token', getresponse['access_token']);
          session.saveString('token_type', getresponse['token_type']);
        }
      Fluttertoast.showToast(msg:'Token saved');
      // await getUser();
      return print('success');
    }else{
      Fluttertoast.showToast(msg:'Error Code ${sendlogin.statusCode}');
      return print('failure');
    }
   } on SocketException catch (_) {
      return Fluttertoast.showToast(msg:'Connection Timed Out');
    } on TimeoutException catch (_){
      return Fluttertoast.showToast(msg:'Request Timeout, try again');
    } catch (e) {
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
            if(getresponse[responseData[i]] is String){
              session.saveString(nameSession[i], getresponse[responseData[i]]);
            }else if(getresponse[responseData[i]] is int){
              session.saveInteger(nameSession[i], getresponse[responseData[i]]);
            }else if(getresponse[responseData[i]] is bool){
              session.saveBool(nameSession[i], getresponse[responseData[i]]);
            }
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
        if(result[getData[i]] is String){
          result[getData[i]] = await session.getString(getData[i]);
        }else if(result[getData[i]] is int){
          result[getData[i]] = await session.getInteger(getData[i]);
        }else if(result[getData[i]] is bool){
          result[getData[i]] = await session.getBool(getData[i]);
        }
      }
    }
    return result;
  }
}

class Get{
  Session session = new Session();
  String name;
  String customrequest = '';
  bool withbody;
  final header;
  String customurl;
  String errorMessage;
  String successMessage;
  bool logResponse;
  Get({Key key , this.name , this.header , this.withbody , this.customrequest , this.customurl, this.errorMessage,this.logResponse, this.successMessage});

  request() async {

    if(customurl != null && customurl != ''){
      url = customurl;
    }


    try{
      dynamic acc = await session.getString('token_type');
      dynamic auth = await  session.getString('access_token');
      String token = "$acc $auth" ;
      
      final data = await http.get(url + name + customrequest,
        headers : {
          'Accept' : 'application/json',
          'Authorization' : token,
        },
      );
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
      return 'failure';
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
  String name;
  dynamic body;
  final header;
  String errorMessage;
  String successMessage;
  bool logResponse;
  String customurl;

  Post({Key key , this.name , this.header,this.body , this.customurl,this.errorMessage,this.logResponse, this.successMessage});
  request() async {
    if(customurl != null && customurl != ''){
      url = customurl;
    }

    try{
      dynamic acc = await session.getString('token_type');
      dynamic auth = await  session.getString('access_token');
      String token = "$acc $auth" ;

      final data = await http.post(url+name,
        body : body,
        headers : {
          'Accept' : 'application/json',
          'Authorization' : token,
        },
      );
      dynamic dataresponse = json.decode(data.body);
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
      return 'gagal';
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