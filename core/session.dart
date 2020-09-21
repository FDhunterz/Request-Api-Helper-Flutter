import 'package:shared_preferences/shared_preferences.dart';

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