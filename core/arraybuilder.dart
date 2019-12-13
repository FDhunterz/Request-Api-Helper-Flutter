import 'package:flutter/cupertino.dart';

class BuildArray{
  List list;
  List value;
  List singlelist;
  List singlevalue;
  BuildArray({Key key , this.list , this.value , this.singlelist , this.singlevalue});
  Map<String, dynamic> build = Map();
  array() async {
  double count = value.length / list.length;
  int ulang= 0;
    for(var i = 0 ; i < list.length ; i++){
      build[list[i]] = [];
    }

    for(var j = 0 ; j < list.length ; j++){
      for(var i = 0 + ulang ; i < count.round() ; i++){
        build[list[j]].add(value[j + (list.length * i)]);
        }
    }
    return build;
  }

  withsingglearray() async {
    await array();
    for(var i = 0; i < singlelist.length ; i++){
      
      build[singlelist[i]] = singlevalue[i];
    }

    print(build.toString());
    return build;
  }
}