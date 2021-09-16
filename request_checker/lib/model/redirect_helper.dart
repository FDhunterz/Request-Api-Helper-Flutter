import 'package:flutter/material.dart' show Widget;

class Redirects {
  /// if redirect with custom widget
  Widget? widget;

  /// if redirect is active
  bool? toogle;

  Redirects({this.toogle, this.widget});
}
