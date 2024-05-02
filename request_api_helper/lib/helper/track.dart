import 'package:request_api_helper/global_env.dart';

class Track{
  static DateTime? _time; 
  static start(){
    if(ENV.data?.debug ?? false){

      _time = DateTime.now();
    }
  }

  static debug(message){
    if(ENV.data?.debug ?? false){
      if(_time != null){
      final getMS = DateTime.now().difference(_time!).inMilliseconds;
      print('${getMS}ms $message');}
    }
  }
  
  static close(){
    _time = null;
  }
}