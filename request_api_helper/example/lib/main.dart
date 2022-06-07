import 'package:example/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Request Api Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText2: GoogleFonts.karla(textStyle: textTheme.bodyText2),
        ),
      ),
      home: const StartView(),
    );
  }
}
