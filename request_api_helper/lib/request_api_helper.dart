library request_api_helper;

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'timeout.dart';

// example https://this.com/api/
String url;

// example https://this.com/
String noapiurl;

// Custom api / Laravel Passport
String key;

// Laravel Get Login Passport
String clientsecret;
String clientId;
String grantType = 'password';

class Env{
  /// example https://this.com/api/
  String confurl = '';

  /// example https://this.com/
  String confnoapiurl = '';

  /// Custom api / Laravel Passport
  String confkey = "";

  /// Laravel Get Login Passport
  String confclientsecret = '';
  /// Laravel Client Id
  String confclientId = '';
  /// Laravel Grant Type default 'password'
  String confgrantType = 'password';

  Env({this.confurl , this.confnoapiurl , this.confkey , this.confclientsecret , this.confclientId , this.confgrantType});
  void save()
  {
    url = confurl;
    noapiurl = confnoapiurl;
    key = confkey;
    clientsecret = confclientsecret;
    clientId = confclientId;
    grantType = confgrantType;
  }
}

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
  /// show Exception
  bool exception = false;

  Auth({Key key , this.nameSession, this.responseData , this.getData , this.name ,@required this.username,@required this.password,@required this.exception});


  login() async {
  print(url);
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
      if(exception){
        Fluttertoast.showToast(msg:'Error Code ${sendlogin.statusCode}');
      }
      return print('failure');
    }
   } on SocketException catch (_) {
      return Fluttertoast.showToast(msg:'Connection Timed Out');
    } on TimeoutException catch (_){
      return Fluttertoast.showToast(msg:'Request Timeout, try again');
    } catch (e) {
      if(exception){
        print('error Exception');
        Fluttertoast.showToast(msg:'Error Exception');
        Fluttertoast.showToast(msg:e.toString());
        return print(e.toString());
      }
    }
  }

  getUser() async {
    dynamic getresponse = await Get(name: name,customrequest: '',exception: false).request();
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
  /// show success message , use = 'default' to get 'message' : 'your message' response
  String successMessage;
  /// show log print response , use = 'default' to get 'message' : 'your message' response
  bool logResponse;
  /// show Exception
  bool exception = false;
  /// use timeout=true for default routing timeout view
  ///
  ///use timeout=your_route
  dynamic timeout;
  Get({Key key , this.name , this.customrequest , this.customUrl, this.errorMessage,this.logResponse, this.successMessage,@required this.exception , this.timeout});

  request([context]) async {
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
        await Response().start(dataresponse,1,false);
      }
      
    if(data.statusCode == 200){
      if(successMessage == 'default'){
        Fluttertoast.showToast(msg:dataresponse['message']);
      }else if(successMessage != null && successMessage != ''){
        Fluttertoast.showToast(msg:successMessage);
      }
      return dataresponse;
    }else{
      if(errorMessage == 'default'){
        Fluttertoast.showToast(msg:dataresponse['message']);
      }else if(errorMessage != null && errorMessage != ''){
        Fluttertoast.showToast(msg:errorMessage);
      }
      if(exception){
        Fluttertoast.showToast(msg:dataresponse);
      }
      print('${data.statusCode}');
      return 'Failed, Code ${data.statusCode}';
    }

    } on SocketException catch (_) {
      if(timeout != null){
        if(context != null){
          if(timeout is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Connection(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeout, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else{
        Fluttertoast.showToast(msg:'Connection Timed Out',);
      }
    } on TimeoutException catch (_){
      if(timeout != null){
        if(context != null){
          if(timeout is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Timeout(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeout, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else{
        Fluttertoast.showToast(msg:'Request Timed Out');
      }
    } catch (e) {
      if(exception){
        Fluttertoast.showToast(msg:'Error Exception');
        Fluttertoast.showToast(msg:e.toString());
        print(e.toString());
      }
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
  /// show success message , use = 'default' to get 'message' : 'your message' response
  String successMessage;
  /// show log print response , use = 'default' to get 'message' : 'your message' response
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
  /// show Exception
  bool exception = false;
  /// use timeout=true for default routing timeout view
  ///
  ///use timeout=your_route
  dynamic timeout;



  Post({Key key , this.name,this.body , this.customUrl,this.errorMessage,this.logResponse, this.successMessage , this.customHeader ,@required this.exception, this.timeout});
  request([context]) async {

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
        await Response().start(dataresponse,1,false);
      }

      if(data.statusCode == 200){
        if(successMessage == 'default'){
          Fluttertoast.showToast(msg:dataresponse['message']);
        }else if(successMessage != null && successMessage != ''){
          Fluttertoast.showToast(msg:successMessage);
        }
      return dataresponse;
    }else{
      print('Error Code ${data.statusCode}');
      if(errorMessage == 'default'){
          Fluttertoast.showToast(msg:dataresponse['message']);
      }else if(errorMessage != null && errorMessage != ''){
          Fluttertoast.showToast(msg:errorMessage);
      }
      if(exception){
        Fluttertoast.showToast(msg:dataresponse);
      }
      return 'Failed, Code ${data.statusCode}';
    }

    

    } on SocketException catch (_) {
      if(timeout != null){
        if(context != null){
          if(timeout is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Connection(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeout, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else{
        Fluttertoast.showToast(msg:'Connection Timed Out',);
      }
    } on TimeoutException catch (_){
      if(timeout != null){
        if(context != null){
          if(timeout is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Timeout(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeout, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else{
        Fluttertoast.showToast(msg:'Request Timed Out');
      }
    } catch (e) {
      if(exception){
        Fluttertoast.showToast(msg:'Error Exception');
        Fluttertoast.showToast(msg:e.toString());
        print(e.toString());
      }
    }
  }
}

class Response{
  dynamic edited;
  dynamic total;
  int loopLvl = 0;
  String tab = '  ';
  String tabLvl = '';
  Map<dynamic,dynamic> thisarrlvl = <dynamic,dynamic>{};
  Map<dynamic,dynamic> thisendkey = <dynamic,dynamic>{};
  
  Response({this.total});
  
  start(thisarr,lvl,arrayobject) async {
    print('please wait the process may take a long time...');
    await replaceArr(thisarr,lvl,arrayobject);      
  }
  
  replaceArr(thisarr,lvl,arrayobject,[endKey]){
   thisarrlvl[lvl] = thisarr;
   thisendkey[lvl] = endKey != null ? endKey : '';
   bool arrobj = arrayobject;
   
   if(thisarrlvl[lvl] is Map){
      if(lvl == 1){
        tabLvl = '';
      }
      if(arrobj == true){          
      }else{
        tabLvl += '$tab';
      }
      thisarrlvl[lvl].forEach((key,value){
         if(lvl == 1){
           tabLvl = '';
         }
         if(value is String || value is int || value is bool){ 
          print('$tabLvl$key : $value');
         }else if(value is List){
           print('$tabLvl $key [');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj,key);
         }else{
           print('$tabLvl$key');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
         }
      });
    }else if(thisarrlvl[lvl] is List){
     dynamic inlist = '';
      for(int i = 0; i < thisarrlvl[lvl].length;i++){
         if(lvl == 1){
           tabLvl = '';
         }
         if(thisarrlvl[lvl][i] is Map){
           if(lvl > 1){
             if(i == 0){           
               tabLvl += '$tab';
             }
           }
         }else{
           if(i == 0){
             tabLvl += '$tab';
           } 
         }
         if(thisarrlvl[lvl][i] is String || thisarrlvl[lvl][i] is int || thisarrlvl[lvl][i] is bool)     
         {  
           inlist += '${thisarrlvl[lvl][i]}, ';
         }else{
            if(thisarrlvl[lvl][i] is Map || thisarrlvl[lvl][i] is List){
               if(i > 0){
                  print(' ');
               }
               arrobj = true;
            }else{
               arrobj = false;
            }
            thisarrlvl[lvl + 1] = thisarrlvl[lvl][i];
            replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
            if(thisarrlvl[lvl][i] is Map){
               if(i == thisarrlvl[lvl].length - 1){
                  if(lvl > 1){
                    print('$tabLvl], // End ${thisendkey[lvl]}');
                  }
               }
            }
         }
      } 
      if(inlist != ''){
       print('$tabLvl $inlist], // End ${thisendkey[lvl]}');
      }
      arrobj = false;
    }else{
      if(lvl == 1){
        tabLvl = '';
      }
      print('$tabLvl${thisarrlvl[lvl]}');
    }
  }
}

class Session {
  
  /// parameter 1 = header , parameter 2 = value
  /// note : the name must be different from other data types
  Future<dynamic> save(String name,dynamic value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if(value is String){
      preferences.setString(name, value);
      return true;
    }else if(value is int){
      preferences.setInt(name, value);
      return true;
    }else if(value is bool){
      preferences.setBool(name, value);
      return true;
    }else{
      return 'Type Data Tidak Diketahui';
    }
  }

  Future<dynamic> load(String name) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool typeBool = false; 
    bool typeString = false; 
    bool typeInt = false; 

    try{
      preferences.getBool(name);
      typeBool = true;
    }catch(e){
      try{
        preferences.getInt(name);
        typeInt = true;
      }catch(e){
        try{
          preferences.getString(name);
          typeString = true;
        }catch(e){

        }
      }
    }
    
    if(typeString != false ){
      return preferences.getString(name);
    }else if(typeInt != false){
      return preferences.getInt(name);
    }else if(typeBool != false){
      return preferences.getBool(name);
    }else{
      print('Tidak Ditemukan');
      return false;
    }
  }
  
  Future<bool> clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return true;
  }
}

