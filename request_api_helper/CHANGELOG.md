## 4.0.5+1
* encrypt bug fixed

## 4.0.5
* attribute encrypted session data to encrypt data (optional)

## 4.0.4+4
* request isolate bug fixed

## 4.0.4+3
* request body bug fixed

## 4.0.4+2
* request with isolate (trial)

## 4.0.4
* isolate issue fixed

## 4.0.4
* onProgress post, get now added
* bug fixed header in file send
* removing webview

## 4.0.3+4
* timeout bug fixed

## 4.0.3 - Download Queue
* RequestApiHelper.init() => add maxDownload
* RequestApiHelper now have navigatorKey
* RequestApiHelperApp now have MaterialApp
* have Navigator `RequestApiHelper.to`,`RequestApiHelper.replaceTo`, `RequestApiHelper.replaceNameTo`


## 4.0.2 - Example In Preview
* Api.download
* RequestApiHelper.totalDataUsed in bytes


## 4.0.1+2 - Example In Preview
* optimize loading


## 4.0.1 - Example In Preview
* tutorial in example now
* timeout
* minor bug


## 4.0.0+6 - 
* Change Session base code to database that grand access to background process


## 4.0.0+5 - 
* withloading


## 4.0.0+2 - 
* post body not include (fixed)
* add Session clear and delete


## 4.0.0+1 - add Error, auth error
* auth error function
* error function


## 4.0.0 - Major Upgrade, removing loading
* request stack management
* when push navigator, request is cancel


## 3.0.1+4 - Bug Auth
* fixed


## 3.0.1+2 - Bug StatusCode
* fixed


## 3.0.1+1 - adding Upload Callback (uploaded,total)
* callback upload file size added


## 3.0.0+14 - adding single context
* single context for triggering redirect in multiple request


## 3.0.0+10 - Bug error return null data
* Bug Fixed


## 3.0.0+9 - Bug RequestApiHelperConfigData
* Bug Fixed
* adding Session delete function;


## 3.0.0+5 - change RequestApiHelperConfigData
* Change RequestApiHelperConfigData to RequestApiHelperConfigData


## 3.0.0+4 - Bug Server Switcher
* fixing error saved server


## 3.0.0+3 - Bug Loading
* adding socket , timeout exception function


## 3.0.0+1 - Bug Loading
* Fixed Loading Bug


## 3.0.0 - Upgrade And Optimizing
* changed all Function


## 2.2.6+10 - Update Plugin
* shared_preferences: ^2.0.6
* fluttertoast: ^8.0.8


## 2.2.6+9 - Response Issue
* logResponse bug fixed


## 2.2.6+4 - Compatible FCM
* fixed FCM build error


## 2.2.6+2 - Version Request
* Update Http Version


## 2.2.6 - Version Request
* add version config


## 2.2.5+11 - Fixing Bug
* fixed bug LogResponse


## 2.2.5+8 - Fixing Bug
* fixed bug authredirect , succes exception pop 2x
## 2.2.5+1 - adding Atributes
* fixed bug in file upload batch


## 2.2.5 - adding Atributes
* adding onReloadSubmited, onReloadDissmiss (Post/Get)
* change 'access_token' to 'token' saving login token


## 2.2.4+1 - authErrorRedirect always triggered
* now authErrorRedirect only trigger at 401(Post/Get)


## 2.2.4 - File Add to List
* file now can send in List (Post)


## 2.2.3+1 - Bug Fixed
* withLoading Never closed (Get)
* Header Not Added with file (Post)
* withLoading added in global configuration (Env)


## 2.2.3 - Get Request
* customHeader -> added (Get)
* authErrorRedirect : Login() (statefull widget) -> added 
* singleContext -> added (bool) escaping context rules (rules : remove multiple push context)
* removing bug multiple push TimeoutRedirect / SocketRedirect  


## 2.2.2 - Change Function
* withLoading -> added


## 2.2.1 - Change Function
* Session().save() to Session.save()
* onError(code,response) -> added
* onSuccess(response) -> added
* Env save Request Configuration global 


## 2.2.0 - Raw Response
* onComplete(v) -> added
* beforeSend() -> added
* onTimeout() -> added
* onSocket() -> added
* timeout -changed before -> dynamic | after -> int 
* onException(v)->added 
* (dynamic) timeoutRedirect -> added
* (dynamic) socketRedirect -> added
* (String)timeoutMessage -> added
* (String)socketMessage -> added
* Get customRequest -> String - changed body -> Map
* null body checked
* remove Auth()


## 2.1.1 - Image
* Post add attribute file


## 2.1.0+5 - Readme
* Readme Update


## 2.1.0 - Server Swither
* Server Switcher button


## 2.0.6+1 - Bug in logResponse.

* adding States for call setstate other class
* Fixing Bug logResponse


## 2.0.5 - Return Message.

* default SuccessMessage & ErrorMessage
* Example Response Api {
    'message' : 'Your Message', 
    'data' : 'any data'
}


## 2.0.4+1 - Timeout Connection Routing.

* Timeout View Routing
* Fixing Bug


## 2.0.3+2 - 3 - Readme.

* Readme Update


## 2.0.3+1 - Change All Method.

* Post request.
    * with log response,
    * with exception (true/false),
* Get request.
    * with log response,
    * with exception (true/false),
* Session save.
* Session load.
