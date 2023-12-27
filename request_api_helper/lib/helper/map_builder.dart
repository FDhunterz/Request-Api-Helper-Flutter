class MapBuilder {
  static Map<String, String> buildStringisList(String? key, value, {lastKey}) {
    Map<String, String> d = {};
    if (lastKey != null) {
      for (int i = 0; i < value.length; i++) {
        if (value[i] is Map) {
          d.addAll(buildStringisMap(value[i], lastKey: "$lastKey[$i]"));
        } else {
          d.addAll({"$lastKey[$i]": value[i].toString()});
        }
      }
    } else {
      for (int i = 0; i < value.length; i++) {
        if (value[i] is Map) {
          d.addAll(buildStringisMap(value[i], lastKey: "$key[$i]"));
        } else {
          d.addAll({"$key[$i]": value[i].toString()});
        }
      }
    }

    return d;
  }

  static Map<String, String> buildStringisMap(data, {lastKey}) {
    Map<String, String> d = {};
    if (lastKey != null) {
      data.forEach((key, value) {
        if (value is List) {
          // d.addAll(buildStringisList(key, value));
          // if (value != '') {
          d.addAll(buildStringisList(key, value, lastKey: '$lastKey[$key]'));
          // }
        } else if (value is Map) {
          // if (value != '') {
          d.addAll(buildStringisMap(value, lastKey: '$lastKey[$key]'));
          // }
        } else {
          if (value != '') {
            d.addAll({'$lastKey[$key]': value.toString()});
          }
        }
      });
    } else {
      data.forEach((key, value) {
        if (value is List) {
          // if (value != '') {
          d.addAll(buildStringisList(key, value));
          // }
        } else if (value is Map) {
          // if (value != '') {
          d.addAll(buildStringisMap(value, lastKey: "$key"));
          // }
        } else {
          if (value != '') {
            d.addAll({'$key': value.toString()});
          }
        }
      });
    }

    return d;
  }

  static build(data) {
    Map<String, String> builder = {};
    if (data is Map) {
      builder.addAll(buildStringisMap(data));
    }
    return builder;
  }
  

  static show(data) {
    data.forEach((k, v) {
      print('$k : $v');
    });
  }
}
