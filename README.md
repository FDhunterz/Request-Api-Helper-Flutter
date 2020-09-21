# Request Api Helper Flutter V 2.0.2
 Helper Request Post , get , login passport (Passport Laravel)
 
 > in dependendencies
  - http:
  - shared_preferences:
  - fluttertoast:	
  
  <hr>
  
 > how to use ?
 
 - Copy core to lib
 
 import api.dart in your dart project
   
 in setting env.dart change :
  - url (yoururl.com/api/) 
  - clientsecret (for passport laravel);
  - etc
 
  <hr>
  
 > Make Login Session Function;
 - make function
 
 signin() async {
    <br>
    // login process (token auto saved)
    <br>
    await Auth(username: 'alpha' , password: '123456').login();
    <br>
  }
  
 > get , save , delete , clear Session data Easy
 - create function 
 
 sessionTutorial() async {
    <br>
    // save all Type <br>
    // caution : name head must be different from other type data<br>
    await Session().save('my_name','Faizal'); <br>
    await Session().save('my_number',1); <br>
    await Session().save('my_bool',true); <br>
  <br>
   // load all type <br>
   String myname = await Session().load('my_name);<br>
   int myint = await Session().load('my_int);<br>
   bool mybool = await Session().load('my_bool);<br>
   <br>
   // delete all type<br>
   await Session.delete('my_name');<br>
   <br>
   // clear all data<br>
   await Session.clear();<br>
  }
  
 
 > send request get;
 
 dynamic response = await Get(name: 'sell(your link)') ).request();
  
  example : 
  - name : sell,
  - customRequest : '?id=1',
  - successMessage (nullable),
  - errorMessage (nullable),
  - logResponse (bool),
  
  <br>
  <br>
  // customUrl<br>
  dynamic response = await Get(customUrl:'https://jsonplaceholder.typicode.com/todos/1',logResponse:true).request();
  
  <hr>
 
 > send request post;
 
 dynamic body = {
    'id' : 1,
    'item' : 10,
 }
 
 dynamic response = await Post(name : 'checkout',body : body, successMessage:'Thanks For Buying' , errorMessage:'Problem With Server').request();
  
  example :
  - name : link name,
  - customurl : link url (https://www.my.com/api/),
  - successMessage (nullable),
  - errorMessage (nullable),
  - logResponse (bool),
  
  <br>
  <br>
  // customUrl<br>
  dynamic response = await Post(customUrl:'https://jsonplaceholder.typicode.com/todos/1',logResponse:true).request();
  
    
  <hr>
