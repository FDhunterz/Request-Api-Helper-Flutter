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
import 'package:http_parser/http_parser.dart';
import 'response.dart';

export 'response.dart';
export 'serverSwitcher.dart';

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

// server selected

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
class Get{
  Session session = new Session();
  /// location : 127.0.0.1/myapps/api/['this is name']
  /// 
  /// name = store_data;
  String name;
  Map<String,dynamic> body = {};
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
  /// use timeoutRedirect=true for default routing timeout view
  ///
  ///use timeoutRedirect=your_route
  dynamic timeoutRedirect;

  /// use socketRedirect=true for default routing no internet access view
  ///
  ///use socketRedirect=your_route
  dynamic socketRedirect;
  /// default 10000 ms
  int timeout;
  /// show timeout message
  String timeoutMessage;

  /// show Socket Exception message
  String socketMessage;
  
  /// do a function with if timeout;
  Function onTimeout;

  /// do a function with if no internet;
  Function onSocket;

  ///  show raw response from server
  Function onComplete;

  /// function before send
  Function beforeSend;

  // function if Exception
  Function onException;

  Get({Key key , this.name , this.body , this.customUrl, this.errorMessage,this.logResponse, this.successMessage,@required this.exception , this.timeout, this.onTimeout ,this.onSocket, this.onComplete, this.beforeSend, this.onException,this.socketMessage,this.socketRedirect,this.timeoutMessage,this.timeoutRedirect});

  request([context]) async {
    dynamic data;
    dynamic header;
    try{
      if(beforeSend != null){
        await beforeSend();
      }
      dynamic acc = await session.load('token_type');
      dynamic auth = await session.load('access_token');
      String token = "$acc $auth" ;

      if(auth != null && auth != ''){
        header = {
          'Accept' : 'application/json',
          'Authorization' : token,
        };
      }else{
        header = {
          'Accept' : 'application/json',
        };
      }
      String _request = '?';

      if(body != null){
        if(body is Map){
          int _counter = 0;
          body.forEach((key, value) {
            ++_counter;
            if(value == null){
              return Fluttertoast.showToast(msg:'$key No Have a Value');
            }
            if(!(_counter == body.length)){
              _request += '$key=$value&';
            }else{
              _request += '$key=$value';
            }
          });
        }
      }
      
      if(customUrl != null && customUrl != ''){
        data = await http.get(customUrl,
          headers : header
        ).timeout(Duration(milliseconds: timeout != null ? timeout : 10000));
      }else{
        data = await http.get(url + name + _request,
          headers : header
        ).timeout(Duration(milliseconds: timeout != null ? timeout : 10000));
      }

      if(onComplete != null){
        await onComplete(data);
      }else{
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
          print('Failed, Code ${data.statusCode}');
          return {'statusCode' : data.statusCode};
        }
      }

    } on SocketException catch (_) {
      if(socketMessage != null){
        Fluttertoast.showToast(msg:socketMessage,);
      }else if(socketRedirect != null){
        if(context != null){
          if(socketRedirect is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Connection(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => socketRedirect, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else if(onSocket != null){
        await onSocket();
      }
    } on TimeoutException catch (_){
      if(timeoutMessage != null){
        Fluttertoast.showToast(msg:timeoutMessage,);
      }else if(timeoutRedirect != null){
        if(context != null){
          if(timeoutRedirect is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Timeout(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeoutRedirect, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else if(onTimeout != null){
        onTimeout();
      }
    } catch (e) {
      if(onException != null){
          await onException(e.toString());
        }else{
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
  /// use timeoutRedirect=true for default routing timeout view
  ///
  ///use timeoutRedirect=your_route
  dynamic timeoutRedirect;

  /// use socketRedirect=true for default routing no internet access view
  ///
  ///use socketRedirect=your_route
  dynamic socketRedirect;
  /// default 10000 ms
  int timeout;
  /// request body for file
  String fileRequestName;
  String file;

  /// show timeout message
  String timeoutMessage;

  /// show Socket Exception message
  String socketMessage;
  
  /// do a function with if timeout;
  Function onTimeout;

  /// do a function with if no internet;
  Function onSocket;

  ///  show raw response from server
  Function onComplete;

  /// function before send
  Function beforeSend;

  // function if Exception
  Function onException;



  Post({Key key , this.name,this.body , this.customUrl,this.errorMessage,this.logResponse, this.successMessage , this.customHeader ,@required this.exception, this.timeout, this.file , this.fileRequestName , this.onTimeout ,this.onSocket, this.onComplete, this.beforeSend, this.onException,this.socketMessage,this.socketRedirect,this.timeoutMessage,this.timeoutRedirect});
  request([context]) async {
    if(beforeSend != null){
      await beforeSend();
    }
    dynamic data;
    dynamic header;
    try{
      dynamic acc = await session.load('token_type');
      dynamic auth = await  session.load('access_token');
      String token = "$acc $auth" ;
      if(auth != null && auth != ''){
        header = {
          'Accept' : 'application/json',
          'Authorization' : token,
        };
      }else{
        header = {
          'Accept' : 'application/json',
        };
      }

      if(body != null){
        body.forEach((k,v){
          if(v == null){
            return Fluttertoast.showToast(msg:'$k No Have Value');
          }
        });
      }

      if(file != null){
        var request;
        if(customUrl != null && customUrl != ''){
          request = http.MultipartRequest('POST', Uri.parse(customUrl));
          customHeader == null ?? request.headers.addAll(customHeader);
        }else{
          request = http.MultipartRequest('POST', Uri.parse(url+name));
          request.headers.addAll(header);
        }

        if(body != null){
          if(body is Map){
              body.forEach((k,v){
              request.fields[k] = v;
            });
          }
        }

        request.files.add(await http.MultipartFile.fromPath(
          fileRequestName ?? 'file', file,
          contentType: MediaType('application', file.split('.').last)
          )
        );

        data = await request.send().timeout(Duration(milliseconds: timeout != null ? timeout : 120000));
      }else{
        if(customUrl != null && customUrl != ''){
          data = await http.post(customUrl,
            body : body,
            headers : customHeader,
          ).timeout(Duration(milliseconds: timeout != null ? timeout : 10000));
        }else{
          data = await http.post(url+name,
            body : body,
            headers : header,
          ).timeout(Duration(milliseconds: timeout != null ? timeout : 10000));
        }
      }
      
      if(onComplete != null){
        await onComplete(data);
      }else{
        dynamic dataresponse = json.decode(file != null ? await data.stream.bytesToString() : data.body);
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
        } else {
          print('Error Code ${data.statusCode}');
          if(errorMessage == 'default'){
              Fluttertoast.showToast(msg:dataresponse['message']);
          }else if(errorMessage != null && errorMessage != ''){
              Fluttertoast.showToast(msg:errorMessage);
          }
          if(exception){
            Fluttertoast.showToast(msg:dataresponse);
          }
          return {'statusCode' : data.statusCode};
        }
      }
    } on SocketException catch (_) {
      if(socketMessage != null){
        Fluttertoast.showToast(msg:socketMessage,);
      }else if(socketRedirect != null){
        if(context != null){
          if(socketRedirect is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Connection(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => socketRedirect, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else if(onSocket != null){
        await onSocket();
      }
    } on TimeoutException catch (_){
      if(timeoutMessage != null){
        Fluttertoast.showToast(msg:timeoutMessage,);
      }else if(timeoutRedirect != null){
        if(context != null){
          if(timeoutRedirect is bool){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Timeout(), 
              )
            );
          }else{
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => timeoutRedirect, 
              )
            );
          }
        }else{
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }
      }else if(onTimeout != null){
        await onTimeout();
      }
    } catch (e) {
      if(exception){
        if(onException != null){
          await onException(e.toString());
        }else{
          Fluttertoast.showToast(msg:'Error Exception');
          Fluttertoast.showToast(msg:e.toString());
          print(e.toString());
        }
      }
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

class States extends State{
  /// this is function (){ any function };
  VoidCallback setStates;

  /// target to Set State<>
  List<State> states;

  /// example
  /// 
  ///       class BottomNavbars extends State<BottomNavbar>{
  ///         setRefresh(){
  ///           refresh = false;
  ///         }
  /// 
  ///         getRefresh(){
  ///           return refresh;
  ///         }
  ///       }
  /// 
  /// refresh : BottomNavbar()
  dynamic refresh;
  

  States({ @required this.setStates , @required this.states, @required this.refresh});

  rebuildWidgetss() async {
    if (states != null) {
      if(await refresh.getRefresh() == true){
        states.forEach((s) {
          if (s != null && s.mounted) s.setState(setStates ??(){});
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    print(
        "This build function will never be called. it has to be overriden here because State interface requires this");
    return null;
  }  
}