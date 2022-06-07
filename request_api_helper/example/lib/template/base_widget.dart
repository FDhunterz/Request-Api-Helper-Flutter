import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

double _initital = 0;

gesturePercentage(onGesture, context) {
  double base = MediaQuery.of(context).size.width;
  if (_initital < (base * .3)) {
    double range = onGesture - _initital;
    if (range > base * .1) {
      if (!Navigator.canPop(context)) {
        return _onWillPop();
      }
      SystemChrome.restoreSystemUIOverlays();
      Navigator.pop(context);
    }
  }
}

DateTime? currentNow;
Future<bool> _onWillPop() async {
  DateTime now = DateTime.now();
  if (currentNow == null) {
    currentNow = now;
    Timer(const Duration(seconds: 2), () {
      currentNow = null;
    });
  } else if (currentNow!.difference(now).inSeconds < 4) {
    currentNow = null;
    if (!Navigator.canPop(navigatorKey.currentContext!)) {
      SystemNavigator.pop();
    }
    return true;
  }
  return false;
}

class InitControl extends StatelessWidget {
  final Widget? child;
  final bool? doubleClick;
  final bool? safeArea;
  final VoidCallback? onTapScreen;
  final GlobalKey<FormState>? formKey;

  const InitControl({
    Key? key,
    this.child,
    this.doubleClick,
    this.safeArea,
    this.onTapScreen,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: doubleClick != null && doubleClick == true
          ? _onWillPop
          : () async {
              if (!Navigator.canPop(context)) {
                return _onWillPop();
              }
              SystemChrome.restoreSystemUIOverlays();
              return true;
            },
      child: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          SystemChrome.restoreSystemUIOverlays();
          if (onTapScreen != null) {
            onTapScreen!();
          }
        },
        onHorizontalDragStart: (start) {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          SystemChrome.restoreSystemUIOverlays();
          if (onTapScreen != null) {
            onTapScreen!();
          }
          _initital = start.globalPosition.dx;
        },
        onHorizontalDragUpdate: (update) {
          gesturePercentage(update.globalPosition.dx, context);
        },
        onVerticalDragStart: (start) {
          _initital = start.globalPosition.dx;
        },
        onVerticalDragUpdate: (update) {
          gesturePercentage(update.globalPosition.dx, context);
        },
        child: Form(
          key: formKey,
          child: SafeArea(
            top: safeArea ?? false,
            bottom: safeArea ?? false,
            child: child!,
          ),
        ),
      ),
    );
  }
}
