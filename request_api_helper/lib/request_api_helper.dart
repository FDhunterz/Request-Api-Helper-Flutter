library request_api_helper;

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:request_api_helper/background.dart';
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

// config Request
String _errorMessage;
String _successMessage;
bool _logResponse;
bool _exception = false;
dynamic _timeoutRedirect;
dynamic _socketRedirect;
int _timeout;
String _timeoutMessage;
String _socketMessage;
Function _onTimeout;
Function _onSocket;
Function _onComplete;
Function _beforeSend;
Function _onException;
Function _onSuccess;
Function _onError;
dynamic _authErrorRedirect;
dynamic _currentContext;


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

  /// function if Exception
  Function onException;

  /// function after encoded json
  Function onSuccess;

  /// function if code != 200
  Function onError;
  
  // Redrect and remove Session if response [401] 
  dynamic authErrorRedirect;

  Env({
    this.confurl ,
    this.confnoapiurl , 
    this.confkey , 
    this.confclientsecret , 
    this.confclientId , 
    this.confgrantType,
    this.errorMessage,
    this.logResponse, 
    this.successMessage,
    this.exception , 
    this.timeout, 
    this.onTimeout ,
    this.onSocket, 
    this.onComplete, 
    this.beforeSend, 
    this.onException,
    this.socketMessage,
    this.socketRedirect,
    this.timeoutMessage,
    this.timeoutRedirect,
    this.onError,
    this.onSuccess,
    this.authErrorRedirect
  });


  void save()
  {
    url = confurl;
    noapiurl = confnoapiurl;
    key = confkey;
    clientsecret = confclientsecret;
    clientId = confclientId;
    grantType = confgrantType;
  }

  saveConfiguration(){
    _errorMessage = errorMessage;
    _successMessage = successMessage;
    _logResponse = logResponse;
    _exception = exception;
    _timeoutRedirect = timeoutRedirect;
    _socketRedirect = socketRedirect;
    _timeout = timeout;
    _timeoutMessage = timeoutMessage;
    _socketMessage = socketMessage;
    _onTimeout = onTimeout;
    _onSocket = onSocket;
    _onComplete = onComplete;
    _beforeSend = beforeSend;
    _onException = onException;
    _onSuccess = onSuccess;
    _onError = onError;
    _authErrorRedirect = authErrorRedirect;
  }
}

class Get{
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
  /// set custom header on request format 
  /// {  properties : value , other
  /// }
  /// 
  dynamic customHeader;
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

  // function after encoded json
  Function onSuccess;

  // function if code != 200
  Function onError;

  // Redrect and remove Session if response [401] 
  dynamic authErrorRedirect;

  // fill type Widget or true value
  dynamic withLoading;

  // for escaping rules context
  bool singleContext;
  

  Get({Key key , 
      this.name , 
      this.body , 
      this.customUrl, 
      this.errorMessage,
      this.logResponse, 
      this.successMessage,
      this.exception , 
      this.timeout, 
      this.onTimeout ,
      this.onSocket, 
      this.onComplete, 
      this.beforeSend, 
      this.onException,
      this.socketMessage,
      this.socketRedirect,
      this.timeoutMessage,
      this.timeoutRedirect,
      this.onError,
      this.customHeader,
      this.onSuccess,
      this.withLoading,
      this.singleContext,
      this.authErrorRedirect
    });

  request([context]) async {
    await loadConfiguration();
    dynamic data;
    dynamic header;
    if(withLoading != null){
      if(context == null){
        print('REQUIRED! context parameter in .request(context)');
        print('REQUIRED! context parameter in .request(context)');
        print('REQUIRED! context parameter in .request(context)');
      }else{
        isLoading = true;
        BackDark(
          view: withLoading
        ).dialog(context); 
      }
    }

    try{
      if(beforeSend != null){
        await beforeSend();
      }
      dynamic acc = await Session.load('token_type');
      dynamic auth = await Session.load('access_token');
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
          headers : customHeader
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
          if(onSuccess != null){
            return onSuccess(dataresponse);
          }else{
            if(successMessage == 'default'){
              Fluttertoast.showToast(msg:dataresponse['message']);
            }else if(successMessage != null && successMessage != ''){
              Fluttertoast.showToast(msg:successMessage);
            }
            
            if(withLoading != null){
              if(context == null){
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }else{
                isLoading = false;
                Navigator.pop(context);  
              }
            }
            return dataresponse;
          }
        }else{
          if(authErrorRedirect != null){
            if(_currentContext != context || singleContext == true){
              if(context != null){
                Session.clear();
                return Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => authErrorRedirect,  
                  ),(Route<dynamic> route) => false
                );
              }else{
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }
            }
          }
          if(onError != null){
            return onError(data.statusCode,dataresponse);
          }else{
            if(errorMessage == 'default'){
              Fluttertoast.showToast(msg:dataresponse['message']);
            }else if(errorMessage != null && errorMessage != ''){
              Fluttertoast.showToast(msg:errorMessage);
            }
            print('Failed, Code ${data.statusCode}');
            if(withLoading != null){
              if(context == null){
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }else{
                isLoading = false;
                Navigator.pop(context);  
              }
            }
            return {'statusCode' : data.statusCode};
          }
        }
      }

    } on SocketException catch (_) {
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
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
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
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
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
      if(onException != null){
        await onException(e.toString());
      }else{
        Fluttertoast.showToast(msg:'Error Exception');
        Fluttertoast.showToast(msg:e.toString());
        print(e.toString());
      }
    }
  }

  loadConfiguration(){
    if(errorMessage == null){
      errorMessage = _errorMessage;
    }

    if(successMessage == null){
      successMessage = _successMessage;
    }
    
    if(logResponse == null){
      logResponse = _logResponse;
    }
    
    if(exception == null){
      exception = _exception;
    }
    
    if(timeoutRedirect == null){
      timeoutRedirect = _timeoutRedirect;
    }
    
    if(socketRedirect == null){
      socketRedirect = _socketRedirect;
    }

    if(timeout == null){
      timeout = _timeout;
    }

    if(timeoutMessage == null){  
      timeoutMessage = _timeoutMessage;
    }

    if(socketMessage == null){  
      socketMessage = _socketMessage;
    }

    if(onTimeout == null){
      onTimeout = _onTimeout;
    }

    if(onSocket == null){
      onSocket = _onSocket;
    }

    if(onComplete == null){
      onComplete = _onComplete;
    }

    if(beforeSend == null){
      beforeSend = _beforeSend;
    }

    if(onException == null){
      onException = _onException;
    }

    if(onSuccess == null){
    onSuccess = _onSuccess;
    }

    if(onError == null){  
      onError = _onError;
    }

    if(authErrorRedirect == null){
      authErrorRedirect = _authErrorRedirect;
    }
  }
}
class Post{
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

  // function after encoded json
  Function onSuccess;

  // function if code != 200
  Function onError;

  // fill type Widget or true value
  dynamic withLoading;

 // for escaping rules context
  bool singleContext;

  // Redrect and remove Session if response [401] 
  dynamic authErrorRedirect;



  Post({Key key , 
    this.name,
    this.body , 
    this.customUrl,
    this.errorMessage,
    this.logResponse, 
    this.successMessage , 
    this.customHeader , 
    this.exception, 
    this.timeout, 
    this.file , 
    this.fileRequestName , 
    this.onTimeout ,
    this.onSocket, 
    this.onComplete, 
    this.beforeSend, 
    this.onException,
    this.socketMessage,
    this.socketRedirect,
    this.timeoutMessage,
    this.timeoutRedirect,
    this.onError,
    this.onSuccess,
    this.withLoading,
    this.singleContext,
    this.authErrorRedirect
  });
  request([context]) async {
    if(_currentContext != context || singleContext == true){
      _currentContext = context;
    }
    await loadConfiguration();
    if(withLoading != null){
      if(context == null){
        print('REQUIRED! context parameter in .request(context)');
        print('REQUIRED! context parameter in .request(context)');
        print('REQUIRED! context parameter in .request(context)');
      }else{
        isLoading = true;
        BackDark(
          view: withLoading
        ).dialog(context); 
      }
    }
    
    if(beforeSend != null){
      await beforeSend();
    }
    dynamic data;
    dynamic header;
    try{
      dynamic acc = await Session.load('token_type');
      dynamic auth = await  Session.load('access_token');
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
          if(onSuccess != null){
            if(withLoading != null){
              isLoading = false;
              Navigator.pop(context);  
            }
            return onSuccess(dataresponse);
          }else{
            if(successMessage == 'default'){
              Fluttertoast.showToast(msg:dataresponse['message']);
            }else if(successMessage != null && successMessage != ''){
              Fluttertoast.showToast(msg:successMessage);
            }
            if(withLoading != null){
              isLoading = false;
              Navigator.pop(context);  
            }
            return dataresponse;
          }
        } else {
          if(authErrorRedirect != null){
            if(_currentContext != context || singleContext == true){
              if(context != null){
                return Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => authErrorRedirect,  
                  ),(Route<dynamic> route) => false
                );
              }else{
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }
            }
          }

          if(onError != null){
            if(withLoading != null){
              if(context == null){
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }else{
                isLoading = false;
                Navigator.pop(context);  
              }
            }
            return onError(data.statusCode,dataresponse);
          }else{
            print('Error Code ${data.statusCode}');
            if(errorMessage == 'default'){
                Fluttertoast.showToast(msg:dataresponse['message']);
            }else if(errorMessage != null && errorMessage != ''){
                Fluttertoast.showToast(msg:errorMessage);
            }
            if(withLoading != null){
              if(context == null){
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
                print('REQUIRED! context parameter in .request(context)');
              }else{
                isLoading = false;
                Navigator.pop(context);  
              }
            }
            return {'statusCode' : data.statusCode};
          }
        }
      }
    } on SocketException catch (_) {
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
      if(socketMessage != null){
        Fluttertoast.showToast(msg:socketMessage,);
      }else if(socketRedirect != null){
        if(context != null){
          if(_currentContext != context || singleContext == true){
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
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
      if(timeoutMessage != null){
        Fluttertoast.showToast(msg:timeoutMessage,);
      }else if(timeoutRedirect != null){
        if(context != null){
          if(_currentContext != context || singleContext == true){
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
      if(withLoading != null){
        if(context == null){
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
          print('REQUIRED! context parameter in .request(context)');
        }else{
          isLoading = false;
          Navigator.pop(context);  
        }
      }
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

  loadConfiguration(){
    if(errorMessage == null){
      errorMessage = _errorMessage;
    }

    if(successMessage == null){
      successMessage = _successMessage;
    }
    
    if(logResponse == null){
      logResponse = _logResponse;
    }
    
    if(exception == null){
      exception = _exception;
    }
    
    if(timeoutRedirect == null){
      timeoutRedirect = _timeoutRedirect;
    }
    
    if(socketRedirect == null){
      socketRedirect = _socketRedirect;
    }

    if(timeout == null){
      timeout = _timeout;
    }

    if(timeoutMessage == null){  
      timeoutMessage = _timeoutMessage;
    }

    if(socketMessage == null){  
      socketMessage = _socketMessage;
    }

    if(onTimeout == null){
      onTimeout = _onTimeout;
    }

    if(onSocket == null){
      onSocket = _onSocket;
    }

    if(onComplete == null){
      onComplete = _onComplete;
    }

    if(beforeSend == null){
      beforeSend = _beforeSend;
    }

    if(onException == null){
      onException = _onException;
    }

    if(onSuccess == null){
    onSuccess = _onSuccess;
    }

    if(onError == null){  
      onError = _onError;
    }

    if(authErrorRedirect == null){
      authErrorRedirect = _authErrorRedirect;
    }
  }
}

class Session {
  
  /// parameter 1 = header , parameter 2 = value
  /// note : the name must be different from other data types
  static Future<dynamic> save(String name,dynamic value) async{
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

  static Future<dynamic> load(String name) async{
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
  
  static Future<bool> clear() async {
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