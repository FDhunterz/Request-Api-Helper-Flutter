import 'package:example/template/base_widget.dart';
import 'package:example/template/body.dart';
import 'package:flutter/material.dart';

class RequestView extends StatefulWidget {
  const RequestView({Key? key}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  @override
  Widget build(BuildContext context) {
    return InitControl(
      child: body(
        child: Column(
          children: [
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
