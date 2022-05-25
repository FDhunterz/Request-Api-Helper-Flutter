import 'dart:io';

import 'package:sqflite/sqflite.dart';

class DatabaseCompute {
  String? name;
  String? path;

  DatabaseCompute({this.name, this.path});
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

  static Future<Database> connect() async {
    await init();
    Database database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE data(id INTEGER PRIMARY KEY,name TEXT, text TEXT,type TEXT)');
    });

    return database;
  }

  static insert({String? name, String? text, String? type, databasesPath}) async {
    Database db = await connect();
    await db.transaction((txn) async {
      print(name);
      await txn.rawInsert("INSERT INTO data(name,text,type) VALUES('$name','$text','$type')");
    });
  }

  static delete(DatabaseCompute data) async {
    Database db = await connect();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM data WHERE name="${data.name}"');
    });
  }

  static deleteAll(DatabaseCompute data) async {
    Database db = await connect();
    await db.transaction((txn) async {
      await txn.rawInsert('DELETE FROM data');
    });
  }

  static update({String? name, String? text, String? type, databasesPath}) async {
    Database db = await connect();
    await db.transaction((txn) async {
      print(name);
      await txn.rawInsert("UPDATE data SET text='$text' WHERE name='$name' AND type='$type'");
    });
  }

  static Future<String?> getString(DatabaseCompute data) async {
    Database db = await connect();
    List<Map> list = await db.rawQuery('SELECT * FROM data WHERE name="${data.name}" AND type="string"');
    return list.isEmpty ? null : list.first['text'];
  }

  static Future<double?> getDouble(DatabaseCompute data) async {
    Database db = await connect();
    List<Map> list = await db.rawQuery('SELECT * FROM data WHERE name="${data.name}" AND type="double"');
    return list.isEmpty ? null : double.tryParse(list.first['text']);
  }

  static Future<int?> getInt(DatabaseCompute data) async {
    Database db = await connect();
    List<Map> list = await db.rawQuery('SELECT * FROM data WHERE name="${data.name}" AND type="integer"');
    return list.isEmpty ? null : int.tryParse(list.first['text']);
  }

  static Future<bool?> getBool(DatabaseCompute data) async {
    Database db = await connect();
    List<Map> list = await db.rawQuery('SELECT * FROM data WHERE name="${data.name}" AND type="bool"');
    return list.isEmpty
        ? null
        : list.first['text'] == null
            ? null
            : (list.first['text'] == '1' ? true : false);
  }
}
