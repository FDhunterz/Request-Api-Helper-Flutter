import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Session {
  static List data = [];
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();

    var list = await compute(preferences!.getString, 'saved_list');
    if (list != null) {
      final encoded = await json.decode(list);
      data = encoded;
    }
  }

  static Future<bool> save({required String header, String? stringData, bool? boolData, double? doubleData, int? integerData}) async {
    bool feedback = false;
    String typeData = '';
    assert(preferences != null);
    if (stringData != null) {
      feedback = true;
      typeData = 'string';
      await preferences!.setString(header, stringData);
    } else if (boolData != null) {
      feedback = true;
      typeData = 'bool';
      await preferences!.setBool(header, boolData);
    } else if (doubleData != null) {
      feedback = true;
      typeData = 'double';
      await preferences!.setDouble(header, doubleData);
    } else if (integerData != null) {
      feedback = true;
      typeData = 'integer';
      await preferences!.setInt(header, integerData);
    }

    final datas = data.where((e) => e['name'] == header);
    if (datas.isEmpty) {
      data.add({'type': typeData, 'name': header});
      final encode = await compute(json.encode, data);
      preferences!.setString('saved_list', encode);
    }

    return feedback;
  }

  static Future<dynamic> load(header) async {
    final datas = data.where((e) => e['name'] == header);
    if (datas.isEmpty) return null;
    if (datas.first['type'] == 'string') {
      return preferences!.getString(header);
    } else if (datas.first['type'] == 'double') {
      return preferences!.getDouble(header);
    } else if (datas.first['type'] == 'integer') {
      return preferences!.getInt(header);
    } else if (datas.first['type'] == 'bool') {
      return preferences!.getBool(header);
    }
  }

  static Future<bool> delete({String? name, List? nameList}) async {
    if (name != null) {
      data.removeWhere((val) => val['name'] == name);
      preferences!.remove(name);
    } else if (nameList != null) {
      for (var names in nameList) {
        data.removeWhere((val) => val['name'] == names);
        preferences!.remove(names);
      }
    }
    return true;
  }

  static Future<bool> clear() async {
    preferences!.clear();
    return true;
  }
}
