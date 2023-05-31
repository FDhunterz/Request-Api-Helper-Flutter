import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart' show RequestApiHelper;

Future<dynamic> timeTracker(name, Function function, {RequestApiHelperData? config}) async {
  DateTime? now;
  if (config?.debug == true) {
    now = DateTime.now();
  }
  RequestApiHelper.addLog('Start $name');
  dynamic res;
  try {
    res = (await function()); //.timeout(config?.timeout);
  } catch (_) {
    internalHandlingData(_.toString(), debug: kReleaseMode);
  }

  if (config?.debug == true) {
    RequestApiHelper.addLog('Process $name ${DateTime.now().difference(now!).inMilliseconds.toString()} Millisecond');
    print('$name ' + DateTime.now().difference(now).inMilliseconds.toString() + ' Millisecond');
  }

  RequestApiHelper.addLog('end process $name');
  return res;
}

notNullFill(dynamic base, dynamic newData) {
  if (newData != null) {
    return newData;
  }
  return base;
}

handlingData(data, {bool debug = false}) {
  if (data is Map) {
    if (debug) {
      print(data.toString() + ' // Map');
    }
  } else if (data is List) {
    if (debug) {
      print(data.toString() + ' // List');
    }
  } else if (data is String) {
    if (debug) {
      if (data.contains('<script>') || data.contains('</script>') || data.toLowerCase().contains('<html>')) {
        if (RequestApiHelper.baseData?.navigatorKey != null) {
          print('// website response');
          print(data);
        }
      }
    }
  } else if (data is int) {
    if (debug) {
      print(data.toString() + ' // integer');
    }
  } else if (data is double) {
    if (debug) {
      print(data.toString() + ' // double');
    }
  }
}

internalHandlingData(data, {bool debug = false}) {
  if (debug) {
    print('################ ' + data.toString() + ' // Exception');
  }
}

getSize(title, data, {bool debug = false}) {
  List<int> bytes = utf8.encode(data);
  Uint8List conbytes = Uint8List.fromList(bytes);
  if (debug) {
    print(title + ' // ' + (conbytes.lengthInBytes).toString() + ' Bytes');
  }
}
