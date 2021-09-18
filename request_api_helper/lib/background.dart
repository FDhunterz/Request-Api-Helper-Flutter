/// this class used For show Dialog or Loading,
/// [Redirects] class have 2 attributes
/// toogle is [true] or [false]
/// widget for custom Widget you want
/// you can implement like :
///
///     import 'package:request_api_helper/request_api_helper.dart';
///
///     BackDark(
///       view : Redirects(
///         widget: [your_Widget_Here]
///       )
///     );
///
///
import 'package:flutter/material.dart';
import 'model/redirect_helper.dart';

bool isLoading = false;

class BackDark {
  Redirects? view;
  bool? barrierDismissible;
  BackDark({this.view, this.barrierDismissible});
  dialog(context) async {
    Future.delayed(Duration.zero, () {
      return showDialog<void>(
        context: context,
        barrierDismissible: barrierDismissible ?? false, // user must tap button!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return !isLoading;
            },
            child: Center(
              child: view!.widget ?? RefreshProgressIndicator(),
            ),
          );
        },
      );
    });
  }
}
