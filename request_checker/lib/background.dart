
import 'package:flutter/material.dart';

bool isLoading = false ;

class BackDark{
  dynamic view;
  BackDark({
    this.view
  });
  dialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return !isLoading;
          },
          child: Center(
            child: view != null && view != true ? view : RefreshProgressIndicator(),
          ),
        );
      },
    );
  }
}