import 'package:shared_preferences/shared_preferences.dart';

class Session {
  Future<bool> saveString(String name, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(name, value);
    return true;
  }

  Future<String> getString(String name) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(name) ?? "Tidak ditemukan";
  }

  Future<bool> saveInteger(String name, int value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(name, value);
    return true;
  }

  Future<int> getInteger(String name) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(name) ?? 0;
  }

  Future<bool> saveBool(String name, bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(name, value);
    return true;
  }

  Future<bool> getBool(String name) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(name) ?? false;
  }

  Future<bool> clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    return true;
  }
}