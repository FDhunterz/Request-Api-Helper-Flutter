# request_api_helper

## 1.Setting inside main

Env(<br>
    confurl: 'https://url/api/',<br>
    confnoapiurl:  'https://url/',<br>
    confclientId: 'client id laravel',<br>
    confclientsecret: 'client secret laravel',<br>
    confgrantType: 'password',<br>
).save();<br>

set login first<br>

Auth(username: 'your username',password:'your password', exception:false).login()<br>

## 2.how to use Get / Post http?

dynamic response = await Post(<br>
    name: (route after /api/),<br>
    body: {<br>
        'example' : 'this example',<br>
    },<br>
    logResponse: true/false (to see response processed),<br>
    exception : true/false (show exception Error),<br>
).request();<br>

optional customUrl, example = 'https://example.com/api/custom/request/v1' [full url needed].<br>
optional customHeader.<br>

## 3.how to save / load shared_preference?

Session().save('name','FDhunter');<br>
Session().save('number',12390123);<br>
Session().save('login',true);<br>
<br>
note : name session must be different.<br>

String name = await Session().load('name');<br>
int number = await Session().load('number');<br>
bool loginState = await Session().load('login');<br>
