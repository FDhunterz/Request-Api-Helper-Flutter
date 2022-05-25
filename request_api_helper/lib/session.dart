import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'helper/database.dart';

class Session {
  static List data = [];

  static Future<void> init() async {
    var list = await StorageBase.getString(DatabaseCompute(
      name: 'saved_list',
    ));
    if (list != null) {
      final encoded = await json.decode(list);
      data = encoded;
    } else {
      await StorageBase.insert(name: 'saved_list', text: json.encode([]), type: 'string');
    }
  }

  static Future<bool> save({required String header, String? stringData, bool? boolData, double? doubleData, int? integerData}) async {
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
          text: stringData,
          type: 'string',
        );
      } else {
        await StorageBase.insert(
          name: header,
          text: stringData,
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
          text: doubleData.toString(),
          type: 'bool',
        );
      } else {
        await StorageBase.insert(
          name: header,
          text: doubleData.toString(),
          type: 'bool',
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
          text: integerData.toString(),
          type: 'integer',
        );
      } else {
        await StorageBase.insert(
          name: header,
          text: integerData.toString(),
          type: 'integer',
        );
      }
    }

    final datas = data.where((e) => e['name'] == header);
    if (datas.isEmpty) {
      data.add({'type': typeData, 'name': header});
      final encode = await compute(json.encode, data);
      await StorageBase.update(
        name: 'saved_list',
        text: encode,
        type: 'string',
      );
    }

    return feedback;
  }

  static Future<dynamic> load(header) async {
    final datas = data.where((e) => e['name'] == header);
    if (datas.isEmpty) return null;
    if (datas.first['type'] == 'string') {
      return await StorageBase.getString(DatabaseCompute(
        name: header,
      ));
    } else if (datas.first['type'] == 'double') {
      return await StorageBase.getDouble(DatabaseCompute(
        name: header,
      ));
    } else if (datas.first['type'] == 'integer') {
      return await StorageBase.getInt(DatabaseCompute(
        name: header,
      ));
    } else if (datas.first['type'] == 'bool') {
      return await StorageBase.getBool(DatabaseCompute(
        name: header,
      ));
    }
  }

  static Future<bool> delete({String? name, List? nameList}) async {
    if (name != null) {
      data.removeWhere((val) => val['name'] == name);
      await compute(
          StorageBase.delete,
          DatabaseCompute(
            name: name,
          ));
    } else if (nameList != null) {
      for (var names in nameList) {
        data.removeWhere((val) => val['name'] == names);
        await compute(
            StorageBase.delete,
            DatabaseCompute(
              name: names,
            ));
      }
    }
    return true;
  }

  static Future<bool> clear() async {
    await StorageBase.deleteAll(DatabaseCompute());
    return true;
  }
}
