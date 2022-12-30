import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:request_api_helper/request_api_helper.dart';
import 'package:request_api_helper/session.dart';

Widget body({child}) {
  return Scaffold(
    body: Container(
      width: MediaQuery.of(navigatorKey!.currentContext!).size.width,
      height: MediaQuery.of(navigatorKey!.currentContext!).size.height,
      decoration: const BoxDecoration(color: Colors.black),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            child ?? const SizedBox(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget card({child, copyText, status = false}) {
  return StatefulBuilder(builder: (context, state) {
    return GestureDetector(
      onTap: () async {
        await Session.save(header: 'testing_aja_d', doubleData: 1000.290138091283);
        if (copyText != null) {
          Clipboard.setData(ClipboardData(text: copyText));
          // ignore: avoid_print
          status = true;
          // ignore: avoid_print
          print('\x1B[38;5;255mtext has been saved to clipboard');
          state(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(navigatorKey!.currentContext!).size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: status ? Colors.green.withOpacity(.2) : Colors.white.withOpacity(.2),
          border: Border.all(
            color: status ? Colors.green.withOpacity(.4) : Colors.white.withOpacity(0.4),
          ),
        ),
        child: child ?? const SizedBox(),
      ),
    );
  });
}
