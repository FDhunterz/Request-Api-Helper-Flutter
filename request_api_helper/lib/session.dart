import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  /// parameter 1 = header , parameter 2 = value
  /// note : the name must be different from other data types
  static Future<dynamic> save(String name, dynamic value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String typeData = '';
    final getList = await loadList();
    List savedList = getList == null ? [] : json.decode(getList);
    if (value is String) {
      typeData = 'string';
      preferences.setString(name, value);
    } else if (value is int) {
      typeData = 'int';
      preferences.setInt(name, value);
    } else if (value is bool) {
      typeData = 'bool';
      preferences.setBool(name, value);
    } else {
      return 'Type Data Tidak Diketahui';
    }
    savedList.add({'type': '$typeData', 'name': '$name'});
    final encode = json.encode(savedList);
    preferences.setString('saved_list', encode);
    return true;
  }

  static Future<dynamic> loadList() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('saved_list');
  }

  static Future<dynamic> load(String name) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final getList = await loadList();
    List savedList = getList == null ? [] : json.decode(getList);
    bool typeString = false, typeInt = false, typeBool = false;
    savedList.where((val) => val['name'] == name).map((val) {
      if (val['type'] == 'string')
        typeString = true;
      else if (val['type'] == 'int')
        typeInt = true;
      else if (val['type'] == 'bool') typeBool = true;
    }).toString();

    if (typeString != false) {
      return preferences.getString(name);
    } else if (typeInt != false) {
      return preferences.getInt(name);
    } else if (typeBool != false) {
      return preferences.getBool(name);
    } else {
      print('Tidak Ditemukan');
      return null;
    }
  }

  static Future<bool> clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return true;
  }
}
