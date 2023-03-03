import 'dart:io';

import 'package:request_api_helper/helper/encrypt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_query/query.dart';

class DatabaseCompute {
  String? name;
  String? path;
  Crypt? encrypt;

  DatabaseCompute({this.name, this.path, this.encrypt});
}

class StorageBase {
  static String path = '';
  static init() async {
    final databasesPath = Platform.isIOS ? '' : await getDatabasesPath();
    // Get a location using getDatabasesPath
    try {
      path = databasesPath + 'sharedPreferences.db';
    } catch (_) {
      print(_);
    }
  }

  static _decrypt(Crypt? keys, text) {
    try {
      if (keys != null) return keys.decode(text);
      return text;
    } catch (_) {
      return text;
    }
  }

  static Future<DBMerge> connect() async {
    Database database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE data(id INTEGER PRIMARY KEY,name TEXT, text TEXT,type TEXT)');
    });
    return DBMerge(database: database, tableList: []);
  }

  static insert({String? name, String? text, String? type, databasesPath}) async {
    DBMerge db = await connect();
    await db.table('data').data({
      'name': name ?? '',
      'text': text ?? '',
      'type': type ?? '',
    }).insert();
  }

  static delete(DatabaseCompute data) async {
    DBMerge db = await connect();
    await db.table('data').where('name', '=', data.name).delete();
  }

  static deleteAll(DatabaseCompute data) async {
    DBMerge db = await connect();
    await db.table('data').where('name', '!=', '_encrypted_session_master').delete();
  }

  static update({String? name, String? text, String? type, databasesPath}) async {
    DBMerge db = await connect();
    await db.table('data').where('name', '=', name).where('type', '=', type).data({
      'text': text ?? '',
    }).update();
  }

  static Future<String?> getString(DatabaseCompute data) async {
    DBMerge db = await connect();
    List<Map> list = await db.table('data').where('name', '=', data.name ?? '').where('type', '=', 'string').get();
    return list.isEmpty ? null : _decrypt(data.encrypt, list.first['text']);
  }

  static Future<double?> getDouble(DatabaseCompute data) async {
    DBMerge db = await connect();
    List<Map> list = await db.table('data').where('name', '=', data.name ?? '').where('type', '=', 'double').get();
    return list.isEmpty ? null : double.tryParse(_decrypt(data.encrypt, list.first['text']));
  }

  static Future<int?> getInt(DatabaseCompute data) async {
    DBMerge db = await connect();
    List<Map> list = await db.table('data').where('name', '=', data.name ?? '').where('type', '=', 'integer').get();
    return list.isEmpty ? null : int.tryParse(_decrypt(data.encrypt, list.first['text']));
  }

  static Future<bool?> getBool(DatabaseCompute data) async {
    DBMerge db = await connect();
    List<Map> list = await db.table('data').where('name', '=', data.name ?? '').where('type', '=', 'bool').get();
    return list.isEmpty
        ? null
        : list.first['text'] == null
            ? null
            : (list.first['text'] == '1' ? true : false);
  }

  static reset() async {
    await deleteDatabase(path);
  }
}
