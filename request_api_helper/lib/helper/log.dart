import 'dart:convert';
import 'dart:typed_data';

getSize(title, data, {bool debug = false}) {
  List<int> bytes = utf8.encode(data);
  Uint8List conbytes = Uint8List.fromList(bytes);
  if (debug) {
    print(title + ' // ' + (conbytes.lengthInBytes).toString() + ' Bytes');
  }
}
