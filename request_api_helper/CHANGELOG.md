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
