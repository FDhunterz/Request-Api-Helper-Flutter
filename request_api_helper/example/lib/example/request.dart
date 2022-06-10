import 'package:flutter/material.dart';

import '../template/body.dart';

class RequestViewTutorial extends StatefulWidget {
  const RequestViewTutorial({Key? key}) : super(key: key);

  @override
  State<RequestViewTutorial> createState() => _RequestViewTutorialState();
}

class _RequestViewTutorialState extends State<RequestViewTutorial> {
  String importText = """import 'package:request_api_helper/request_api_helper.dart';
import 'package:request_api_helper/module/request.dart';
import 'package:flutter/foundation.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
""";

  String mainDartText = """RequestApiHelper.sendRequest(
    type: Api.get,
    url: name.text,
    config: RequestApiHelperData(
        body: {
            'keys' : 'values',
        },
        onSuccess: (data) {
            response = data.toString();
            setState(() {});
        },
    ),
);""";
  List<bool> statusCopy = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return body(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'make First Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: card(
              status: statusCopy[1],
              copyText: mainDartText,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      mainDartText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                  child: Material(
                    color: Colors.green,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: InkWell(
                      splashColor: Colors.black12,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'You are done? lets try',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
