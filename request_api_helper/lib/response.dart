class Response {
  static String _toTab = ' ';
  static start(data) {
    if (data is Map) {
      print('{');
      ifObject(data, 0);
      print('}');
    } else if (data is List) {
      print('[');
      ifArray(data, 0);
      print(']');
    } else if (data is String) {
      ifOther(data, 'String', 0);
    } else if (data is int) {
      ifOther(data, 'int', 0);
    } else if (data is bool) {
      ifOther(data, 'bool', 0);
    } else if (data == null) {
      ifOther(data, 'null', 0);
    } else if (data is double) {
      ifOther(data, 'double', 0);
    }
  }

  // [value] int
  static ifArray(data, tab, {string}) {
    String thisTab = '';
    int tabs = tab + 1;
    for (int t = 0; t < tabs; t++) {
      thisTab += _toTab;
    }
    if (data[0] is List) {
      print('$thisTab ' + (string ?? '') + ' [');
    } else if (data[0] is Map) {
      print('$thisTab ' + ' {');
    }
    for (var i in data ?? []) {
      if (i is Map) {
        ifObject(i, tabs);
      } else if (i is List) {
        if (i.length == 0) {
          print('$thisTab []');
        } else {
          print('$thisTab  [');
          ifArray(i, tabs);
          print('$thisTab  ]');
        }
      } else if (i is String) {
        ifOther(i, 'String', tabs);
      } else if (i is int) {
        ifOther(i, 'int', tabs);
      } else if (i is bool) {
        ifOther(i, 'bool', tabs);
      } else if (i == null) {
        ifOther(i, 'null', tabs);
      } else if (data is double) {
        ifOther(data, 'double', 0);
      }
    }
    if (data[0] is List) {
      print('$thisTab ]');
    } else if (data[0] is Map) {
      print('$thisTab }');
    }
  }

  // { 'object' : value }
  static ifObject(data, tab, {string}) {
    String thisTab = '';
    int counter = 0;
    int tabs = tab + 1;
    for (int t = 0; t < tabs; t++) {
      thisTab += _toTab;
    }

    data.forEach((k, v) {
      ++counter;
      if (v is Map) {
        print('$thisTab $k : {');
        ifObject(v, tabs, string: k);
        print('$thisTab }');
      } else if (v is List) {
        if (v.length == 0) {
          print('$thisTab $k : []');
        } else {
          print('$thisTab  $k : [');
          ifArray(v, tabs, string: k);
          print('$thisTab ] // end $k');
        }
      } else if (v is String) {
        ifOther('$k : $v', 'String', tabs);
        if (data.length == counter) {
          print('');
        }
      } else if (v is int) {
        ifOther('$k : $v', 'int', tabs);
        if (data.length == counter) {
          print('');
        }
      } else if (v is bool) {
        ifOther('$k : $v', 'bool', tabs);
        if (data.length == counter) {
          print('');
        }
      } else if (v == null) {
        ifOther('$k : $v', 'null', tabs);
        if (data.length == counter) {
          print('');
        }
      } else if (v is double) {
        ifOther('$k : $v', 'double', tabs);
        if (data.length == counter) {
          print('');
        }
      }
    });
  }

  static ifOther(data, type, tab) {
    String thisTab = '';
    int tabs = tab + 1;
    for (int t = 0; t < tabs; t++) {
      thisTab += _toTab;
    }
    print('$thisTab $data // $type');
  }
}
