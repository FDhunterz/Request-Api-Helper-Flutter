import 'package:request_checker/request.dart';
import 'package:request_checker/request_api_helper.dart';

Future<dynamic> timeTracker(name, Function function, {RequestApiHelperData? config}) async {
  DateTime? now;
  if (config?.debug == true) {
    now = DateTime.now();
  }
  final res = await function();

  if (config?.debug == true) {
    print('$name ' + DateTime.now().difference(now!).inMilliseconds.toString() + ' Millisecond');
  }
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
      print(data + ' // String');
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
