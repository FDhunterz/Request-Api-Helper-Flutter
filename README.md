# Request Api Helper Flutter V 1.0.0
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
   
 in setting api.dart change :
  - url (yoururl.com/api/) 
  - clientsecret (for passport laravel);
 
  <hr>
 
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

 await ArrayRequestSend(customurl: 'https://mywebsite/api/' ,nama: 'checkout/save',msg: "Checkout complete" , requestbody: parsemap).senddata();

 
 Note options : 
  - singlehead = for 1 singgle value;
  - singlevalue = only 1 value;
  - list = for many value,
  - value = value of list,
 functions :
 array() = for many value,
 withsinglearray = singgle array + many value include;
 
