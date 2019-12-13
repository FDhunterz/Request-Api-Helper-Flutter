import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growtopia/core/session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

String url = 'https://warungislamibogor-store.alamraya.site/api/';
String noapiurl = 'https://warungislamibogor-store.alamraya.site/';

// Custom api / Laravel Passport
String key = "`e`!-gu@v}l@'[]xNrl(}n/gUSf[0`fs:Z9}I{?/|%bJ]i=Wp=hDUn70y>X^Hi(";

// Laravel Get Login Passport
String clientsecret = '0zxvmtgG2PkVw0NfQ0HwxjKYHVbhoaFBZyDlmJEp';
String clientId = '2';
String grantType = 'password';

class Login{
  Session session = new Session();
  final nama;
  final password;
  Login({Key key , this.nama, this.password});


  proses() async {
   try{
    final sendlogin = await http.post(noapiurl+'oauth/token', body: {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientsecret,
        "username": nama,
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
      Fluttertoast.showToast(msg:'Berhasil Menyimpan Token');
      await getuser();
      return 'sukses';
    }else{
      Fluttertoast.showToast(msg:'Error Code ${sendlogin.statusCode}');
      return 'gagal';
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
    return 'ada yang aneh';
  }

  getuser() async {
    dynamic getresponse = await RequestGet(name: 'user').getdata();
    // print(getresponse['cm_name']);
    if(getresponse.length > 0 ){
      session.saveString('cm_name', getresponse['cm_name']);
      Fluttertoast.showToast(msg:'Login Telah Berhasil');
      String nama = await session.getString('cm_name');
      Fluttertoast.showToast(msg:'berhasil login $nama');
    }else{
    Fluttertoast.showToast(msg:'Akun Anda Tidak Ditemukan');
    }
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