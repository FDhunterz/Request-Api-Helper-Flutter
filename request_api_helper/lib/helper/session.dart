import 'dart:convert';

import 'database.dart';
import 'encrypt.dart';

class Session {
  static List data = [];
  static Crypt? _keys;

  static encrypt(text) {
    if (_keys != null) return _keys?.encode(text);
    return text;
  }

  static decrypt(text) {
    if (_keys != null) return _keys?.decode(text);
    return text;
  }

  static getAllData() async {
    return await StorageBase.getAllData();
  }

  static Future<void> init({bool encrypted = false}) async {
    await StorageBase.init();
    if (encrypted) {
      var getE = await StorageBase.getString(DatabaseCompute(
        name: '_encrypted_session_master',
      ));
      var getiv = await StorageBase.getString(DatabaseCompute(
        name: '_encrypted_session_master_iv',
      ));
      if (getE != null && getiv != null) {
        _keys = Crypt.getKeyFromBase64(getE, ivs: getiv);
      } else {
        final getK = Crypt.getKeyEncrypt().base64;
        _keys = Crypt.getKeyFromBase64(getK);
        if (getE != null) {
          await StorageBase.update(name: '_encrypted_session_master', text: getK, type: 'string');
        } else {
          await StorageBase.insert(name: '_encrypted_session_master', text: getK, type: 'string');
        }
        if (getiv != null) {
          await StorageBase.update(name: '_encrypted_session_master_iv', text: getK, type: 'string');
        } else {
          await StorageBase.insert(name: '_encrypted_session_master_iv', text: _keys!.ivString, type: 'string');
        }
      }
    }
    var list = await StorageBase.getString(DatabaseCompute(
      name: 'saved_list',
    ));

    if (list?.isNotEmpty ?? false) {
      final encoded = await json.decode(list!);
      data.insertAll(0, encoded);
    } else {
      await StorageBase.insert(name: 'saved_list', text: json.encode([]), type: 'string');
    }
  }

  static Future<bool> save({required String header, String? stringData, bool? boolData, double? doubleData, int? integerData}) async {
    try {
      bool feedback = false;
      String typeData = '';
      if (stringData != null) {
        feedback = true;
        typeData = 'string';
        String? getData = await StorageBase.getString(DatabaseCompute(
          name: header,
        ));
        if (getData != null) {
          await StorageBase.update(
            name: header,
            text: encrypt(stringData),
            type: 'string',
          );
        } else {
          await StorageBase.insert(
            name: header,
            text: encrypt(stringData),
            type: 'string',
          );
        }
      } else if (boolData != null) {
        feedback = true;
        typeData = 'bool';
        bool? getData = await StorageBase.getBool(DatabaseCompute(
          name: header,
        ));
        if (getData != null) {
          await StorageBase.update(
            name: header,
            text: boolData ? '1' : '0',
            type: 'bool',
          );
        } else {
          await StorageBase.insert(
            name: header,
            text: boolData ? '1' : '0',
            type: 'bool',
          );
        }
      } else if (doubleData != null) {
        feedback = true;
        typeData = 'double';
        double? getData = await StorageBase.getDouble(DatabaseCompute(
          name: header,
        ));
        if (getData != null) {
          await StorageBase.update(
            name: header,
            text: encrypt(doubleData.toString()),
            type: 'double',
          );
        } else {
          await StorageBase.insert(
            name: header,
            text: encrypt(doubleData.toString()),
            type: 'double',
          );
        }
      } else if (integerData != null) {
        feedback = true;
        typeData = 'integer';
        int? getData = await StorageBase.getInt(DatabaseCompute(
          name: header,
        ));
        if (getData != null) {
          await StorageBase.update(
            name: header,
            text: encrypt(integerData.toString()),
            type: 'integer',
          );
        } else {
          await StorageBase.insert(
            name: header,
            text: encrypt(integerData.toString()),
            type: 'integer',
          );
        }
      }
      if (typeData != '') {
        final datas = data.where((e) => e['name'] == header);

        if (datas.isEmpty) {
          data.add({'type': typeData, 'name': header});
          final encode = json.encode(data);
          await StorageBase.update(
            name: 'saved_list',
            text: encode,
            type: 'string',
          );
        }
      }

      return feedback;
    } catch (_) {
      return false;
    }
  }

  static Future<dynamic> load(header) async {
    final datas = data.where((e) => e['name'] == header);
    if (datas.isEmpty) return null;
    if (datas.first['type'] == 'string') {
      return await StorageBase.getString(DatabaseCompute(
        name: header,
        encrypt: _keys,
      ));
    } else if (datas.first['type'] == 'double') {
      return await StorageBase.getDouble(DatabaseCompute(
        name: header,
        encrypt: _keys,
      ));
    } else if (datas.first['type'] == 'integer') {
      return await StorageBase.getInt(DatabaseCompute(
        name: header,
        encrypt: _keys,
      ));
    } else if (datas.first['type'] == 'bool') {
      return await StorageBase.getBool(DatabaseCompute(
        name: header,
        encrypt: _keys,
      ));
    }
  }

  static Future<bool> delete({String? name, List? nameList}) async {
    if (name != null) {
      data.removeWhere((val) => val['name'] == name);
      await StorageBase.delete(DatabaseCompute(
        name: name,
      ));
    } else if (nameList != null) {
      for (var names in nameList) {
        data.removeWhere((val) => val['name'] == names);
        await StorageBase.delete(
          DatabaseCompute(
            name: names,
          ),
        );
      }
    }
    return true;
  }

  static Future<bool> clear() async {
    await StorageBase.deleteAll(DatabaseCompute());
    return true;
  }

  static resetDataBase() async {
    await StorageBase.reset();
  }
}
