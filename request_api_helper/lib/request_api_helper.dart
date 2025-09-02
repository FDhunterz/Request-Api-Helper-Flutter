library api_helper_v4;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

export 'request.dart';
export 'helper/database.dart';

extension RequestExtension on Response {
  Future<dynamic> convert() async {
    final d = jsonDecode(body);
    return d;
  }
}
