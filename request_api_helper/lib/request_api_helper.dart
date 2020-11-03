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
String _selected;

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
      print('Failed, Code ${data.statusCode}');
      return {'statusCode' : data.statusCode};
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
  /// request body for file
  String fileRequestName;
  String file;



  Post({Key key , this.name,this.body , this.customUrl,this.errorMessage,this.logResponse, this.successMessage , this.customHeader ,@required this.exception, this.timeout, this.file , this.fileRequestName});
  request([context]) async {

    dynamic data;
    dynamic header;
    dynamic res;
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

      if(file != null){
        var request;
        if(customUrl != null && customUrl != ''){
          request = http.MultipartRequest('POST', Uri.parse(customUrl));
          customHeader == null ?? request.headers.addAll(customHeader);
        }else{
          request = http.MultipartRequest('POST', Uri.parse(url+name));
          request.headers.addAll(header);
        }

        if(body is Map){
          body.forEach((k,v){
            request.fields[k] = v;
          });
        }

        request.files.add(await http.MultipartFile.fromPath(
          fileRequestName ?? 'file', file,
          contentType: MediaType('application', file.split('.').last)
          )
        );

        res = await request.send();
      }else{
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
      }

      dynamic dataresponse = json.decode(file != null ? await res.stream.bytesToString() : data.body);
      if(logResponse == true){
        await Response().start(dataresponse,1,false);
      }

      if(file != null ? res.statusCode == 200 : data.statusCode == 200){
        if(successMessage == 'default'){
          Fluttertoast.showToast(msg:dataresponse['message']);
        }else if(successMessage != null && successMessage != ''){
          Fluttertoast.showToast(msg:successMessage);
        }
      return dataresponse;
    }else{
      print('Error Code ${file != null ? res.statusCode : data.statusCode}');
      if(errorMessage == 'default'){
          Fluttertoast.showToast(msg:dataresponse['message']);
      }else if(errorMessage != null && errorMessage != ''){
          Fluttertoast.showToast(msg:errorMessage);
      }
      if(exception){
        Fluttertoast.showToast(msg:dataresponse);
      }
      return {'statusCode' : file != null ? res.statusCode : data.statusCode};
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
  String tabLvl = ' ';
  String tab;
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
      tab = '';
      for(int i = 0; i < lvl - 1;i++){
        tab += tabLvl;
      }
      thisarrlvl[lvl].forEach((key,value){
         if(value is String || value is int || value is bool){ 
          print('$tab$key : $value');
         }else if(value is List){
           if(value.length > 0){
             print('$tab$key [');
           }else{
             print('$tab$key []');
           }
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj,key);
         }else if(value == null){
          print('$tab$key : null');
         }else{
           print('$tab$key');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
         }
      });
    }else if(thisarrlvl[lvl] is List){
      
     dynamic inlist = '';
      for(int i = 0; i < thisarrlvl[lvl].length;i++){
          tab = '';
          for(int i = 0; i < lvl - 1;i++){
            tab += tabLvl;
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
                    print('$tab], /// End ${thisendkey[lvl]}');
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
      tab = '';
      for(int i = 0; i < lvl - 1;i++){
        tab += tabLvl;
      }
      print('$tab${thisarrlvl[lvl]}');
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
class ServerSwitcher extends StatefulWidget{
  /// List > Map Data [{'name' : 'Server 1','id' : 'http://192.168.0.101/myproject' //root folder project}]
  final List servers;
  ServerSwitcher({this.servers});
  button(context){
    return _ServerSwitcher().button(context);
  }
  @override
  _ServerSwitcher createState()=>_ServerSwitcher();
}

class _ServerSwitcher extends State<ServerSwitcher>
{
  List _servers;
  TextEditingController _searching = TextEditingController();

  button(context)
  {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.white.withOpacity(0),
          context: context,
          builder: (BuildContext context) => select(context),
        );
      },
    );
  }

  selected(id,context){
    _selected = id;
    Env(
        confnoapiurl: id,
        confurl: id+'api/',
      ).save();
    Navigator.pop(context);
    setState((){});
  }

  select(context)
  {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7 + MediaQuery.of(context).viewInsets.bottom,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
        decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(10.0),
          topRight: const Radius.circular(10.0))),
        child : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.35,
                  endIndent: MediaQuery.of(context).size.width * 0.35,
                ),
                Text(
                  'Select Server',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height:20),
                
                TextField(
                  controller: _searching,
                  onChanged: (val){
                    _searching = TextEditingController(text:val);
                    setState((){});
                  },
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: 'Searching...',
                      icon: Icon(Icons.search),
                      hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black87)),
                      border:
                      OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      )
                    ),
                  ),

                SizedBox(height:20),

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children:_servers.length == 0 ? [] : _servers.where((value)=> value['name'].toString().toUpperCase().contains(_searching.text.toUpperCase())).map((value)=> 
                        ListTile(
                          leading: Icon(Icons.check, color: _selected == value['id'].toString() ? Colors.green : Colors.transparent,),
                          title: Text(value['name'],
                            style: TextStyle(
                              color: _selected == value['id'].toString() ? Colors.green : Colors.black,
                            )
                          ),
                          onTap: (){
                            selected(value['id'],context);
                          },
                        )
                      ).toList(),  
                    ),
                  ),
                )
              ],
            ), 
          ),
        )
      ),
    );
  }
  @override
  void initState() { 
    super.initState();
    _servers = widget.servers;
    _searching = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return button(context);
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