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
