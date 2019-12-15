import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growtopia/core/session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'env.dart';

// core login

class Auth{
  Session session = new Session();
  final username;
  final password;
  final name;
  List getDataInt;
  List getDataString;
  List getDataBool;
  List nameStringsession;
  List dataStringsession;
  List nameIntsession;
  List dataIntsession;
  List nameBoolsession;
  List dataBoolsession;

  Auth({Key key , this.nameStringsession, this.dataStringsession, this.nameIntsession, this.dataIntsession, this.nameBoolsession, this.dataBoolsession,this.name ,this.username, this.password , this.getDataInt , this.getDataBool , this.getDataString});


  proses() async {
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
          session.saveString('access_token', getresponse['access_token']);
          session.saveString('token_type', getresponse['token_type']);
        }
      Fluttertoast.showToast(msg:'Token saved');
      await getuser();
      return 'success';
    }else{
      Fluttertoast.showToast(msg:'Error Code ${sendlogin.statusCode}');
      return 'failure';
    }
   } on SocketException catch (_) {
      Fluttertoast.showToast(msg:'Connection Timed Out');
    } on TimeoutException catch (_){
      Fluttertoast.showToast(msg:'Request Timeout, try again');
    } catch (e) {
      // Fluttertoast.showToast(msg:e.toString(),
      //   position: ToastPosition.bottom,
      // );
    }
    return 'Something Wrong';
  }

  getuser() async {
    dynamic getresponse = await RequestGet(name: name,customrequest: '').getdata();
    // print(getresponse['cm_name']);
    if(getresponse.length > 0 ){
      
      if(nameStringsession != null){  
        for(var i = 0; i < nameStringsession.length ; i++){
          session.saveString(nameStringsession[i], getresponse[dataStringsession != null ? dataStringsession[i] : nameStringsession[i]]);
        }
      }
      
      if(nameIntsession != null){
        for(var i = 0; i < nameIntsession.length ; i++){
          session.saveInteger(nameIntsession[i], getresponse[dataIntsession != null ? dataIntsession[i] : nameIntsession[i]]);
        }
      }

      if(nameBoolsession != null){
        for(var i = 0; i < nameBoolsession.length ; i++){
          session.saveBool(nameBoolsession[i], getresponse[dataBoolsession != null ? dataBoolsession[i] : nameBoolsession[i]]);
        }
      }

      Fluttertoast.showToast(msg:'Login Success');
    }else{
    Fluttertoast.showToast(msg:'Profile Not Found');
    }
  }

  getsession() async {
    Map <String,dynamic> result = new Map();
    if(getDataString != null){    
      for(var i = 0 ; i < getDataString.length;i++){
        result[getDataString[i]] = await session.getString(getDataString[i]);
      }
    }

    if(getDataInt != null){
      for(var i = 0 ; i < getDataInt.length;i++){
        result[getDataInt[i]] = await session.getInteger(getDataInt[i]);
      }
    }

    if(getDataBool != null){    
      for(var i = 0 ; i < getDataBool.length;i++){
        result[getDataBool[i]] = await session.getBool(getDataBool[i]);
      }
    }


    return result;
  }
}

class RequestGet{
  Session session = new Session();
  String name;
  String customrequest = '';
  bool withbody;
  final header;
  String customurl;
  RequestGet({Key key , this.name , this.header , this.withbody , this.customrequest , this.customurl});

  getdata() async {

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
      print(dataresponse.toString());
      if(data.statusCode == 200){
      return dataresponse;
    }else{
      Fluttertoast.showToast(msg:'Error Code ${data.statusCode}');
      return 'failure';
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

class RequestPost{
  Session session = new Session();
  String name;
  dynamic body;
  final header;
  final msg;
  String customurl;
  RequestPost({Key key , this.name , this.header,this.body,this.msg , this.customurl});
  sendrequest() async {
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
        if(msg != null){
          Fluttertoast.showToast(msg:msg);
        }
      return dataresponse;
    }else{
      Fluttertoast.showToast(msg:'Error Code ${data.statusCode}');
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

class ArrayRequestSend{
  var name;
  var request;
  Map<String,dynamic> requestbody;
  var msg;
  var customurl;
  ArrayRequestSend({Key key , this.name , this.request, this.requestbody , this.msg , this.customurl});
    senddata() async {
    if(customurl != '' || customurl != null){
      url = customurl;
    }
    // Map data;
    try {

      Dio dio = new Dio();

      Response sendpostapi = await dio.post(
        url+name,
        data: requestbody,
      );
      
      print(sendpostapi.statusCode.toString());
      if (sendpostapi.statusCode == 200) {
        dynamic sendpostapiJson = sendpostapi.statusMessage;
        // Fluttertoast.showToast(msg:"from response $sendpostapiJson, ${sendpostapi.data}");
        Fluttertoast.showToast(msg:sendpostapiJson);
        if(msg != null){
          Fluttertoast.showToast(msg:msg);
        }
          // Fluttertoast.showToast(msg:msg);
        return 'success';
      } else {
        Fluttertoast.showToast(msg:'Error Code : ${sendpostapi.statusCode}');
      }
    } on TimeoutException catch (_) {
      return 'Timed out, try again';
    } on SocketException catch (_) {
      return 'Hosting not found';
    } on DioError catch (e) {
      Fluttertoast.showToast(msg:e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg:e.toString());
    }
  }
}

class ArrayImageSend{

}