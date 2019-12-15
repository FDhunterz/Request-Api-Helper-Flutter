# Request Api Helper Flutter V 1.0.1 REV 1
 Helper Request Post , get , Map builder (Support Passport Laravel)
 
 > in dependendencies
  - dio:
  - http:
  - shared_preferences:
  - fluttertoast:	
  
  <hr>
  
 > how to use ?
 
 - Copy core to lib
 
 import 'package:(your_name_project)/core/api.dart';
   
 in setting env.dart change :
  - url (yoururl.com/api/) 
  - clientsecret (for passport laravel);
  - etc
 
  <hr>
  
 > Make Login Session Function;
 - make function
 
 signin() async {

    // for return of API
    
    List sessionint = ['cm_id'];

    // for return of API

    List sessionString = ['cm_name','cm_code','cm_email','cm_nphone'];

    // for title In SharedPreference type Integer

    List headsessionint = ['id'];

    // for title In SharedPreference type String
  
    List headsessionString = ['name','code','email','telepon'];

    dynamic check = await Auth(name: 'user', username: 'alpha' , password: '123456' , nameStringsession: headsessionString, nameIntsession: headsessionint,dataStringsession: sessionString , dataIntsession: sessionint).getuser();

    print(check);

  }
  
 > get Session data Easy
 - create function 
 
 showaccount() async {
    
    // title of Shared Preference String
    
    List sessionString = ['name'];
    
    // title of Shared Preference Interger
    
    List sessionInt = ['id'];
    
    dynamic result = await Auth(getDataString:sessionString , getDataInt: sessionInt).getsession();
    
    print(result); 
  
  }
  
 
 > send request get;
 
 dynamic response = await RequestGet (name: 'sell(your link)', customrequest:''(if null you can use '') ).getdata();
 print(dynamic);
  
  example : 
  - name : sell,
  - customrequest : '?id=1',
 
  <hr>
 
 > send request post;
 
 dynamic body = {
    'id' : 1,
    'item' : 10,
 }
 
 dynamic response = await RequestPost(name : 'checkout',body : body, msg:"checkout done").sendrequest();
  
  example :
  - name : link name,
  - customurl : link url (https://www.my.com/api/),
  - msg : if success trigger toast,
    
  <hr>
 
 > send request map / array;
 
 first make List ;
 List header = ['id','name','something'];
 List value = [];
 
 for(var i = 0 < i < response.length;i++){
    value.add(response[i]['id']);
    value.add(response[i]['name']);
    value.add(response[i]['something']);
 }
 
 List singlehead = ['bank','note'];
 List singlevalue = ['12389712398723','my checkout'];
 
parse List to Map <br>

Map<String,dynamic> parsemap = BuildArray(singlelist: singlehead , singlevalue:  singlevalue , list: head , value: value).withsinglearray(); 

send to server<br>

 await ArrayRequestSend(customurl: 'https://mywebsite/api/' ,name: 'checkout/save',msg: "Checkout complete" , requestbody: parsemap).senddata();

 
 Note options : 
  - singlehead = for 1 singgle value;
  - singlevalue = only 1 value;
  - list = for many value,
  - value = value of list,
 functions :
 array() = for many value,
 withsinglearray = singgle array + many value include;
 
