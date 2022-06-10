import 'dart:convert';

import 'package:example/example/parse.dart';
import 'package:example/main.dart';
import 'package:example/template/base_widget.dart';
import 'package:example/template/body.dart';
import 'package:flutter/material.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

class RequestView extends StatefulWidget {
  const RequestView({Key? key}) : super(key: key);

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final controller = TextEditingController(text: 'https://reqbin.com/');
  final name = TextEditingController(text: 'sample/post/json');
  final parameter = TextEditingController(text: 'title:DNA\nbody:RNA');
  final header = TextEditingController(text: 'Accep:application/json');
  final restApi = TextEditingController(text: 'get');
  String param = '';
  String response = '';
  Map<String, dynamic> bodys = {};

  @override
  void initState() {
    super.initState();
    RequestApiHelper.save(
      RequestApiHelperData(
        baseUrl: controller.text,
        navigatorKey: navigatorKey,
        debug: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InitControl(
      child: body(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: controller,
                decoration: const InputDecoration(
                  label: Text('Server'),
                ),
                onChanged: (data) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 12,
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('saved')));
                          RequestApiHelper.save(
                            RequestApiHelperData(
                              baseUrl: controller.text,
                              navigatorKey: navigatorKey,
                              debug: false,
                            ),
                          );
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'You are done? Save it',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: restApi,
                decoration: const InputDecoration(
                  label: Text('Rest Api (post,get,put,delete)'),
                ),
                onChanged: (data) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: name,
                decoration: const InputDecoration(
                  label: Text('Request To'),
                ),
                onChanged: (data) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('link generated : ' + controller.text + name.text),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: header,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('Custom Header'),
                  hintText: 'enter to next parameter(Optional)',
                ),
                onChanged: (data) {},
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: parameter,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('Body / Parameter'),
                  hintText: 'enter to next parameter',
                ),
                onChanged: (data) {
                  param = '';
                  if (data.isNotEmpty && restApi.text == 'get') {
                    final split = data.split('\n');
                    int count = 0;
                    if (split.isNotEmpty) {
                      param += '?';
                    }
                    for (var i in split) {
                      ++count;
                      final split2 = i.split(':');
                      if (count > 1) {
                        param += '&';
                      }
                      param += split2.first + '=' + split2.last;
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('link generated : ' + (restApi.text == 'get' ? (controller.text + name.text + param) : ' Map data')),
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
                          response = '';
                          setState(() {});
                          RequestApiHelper.sendRequest(
                            type: restApiParse(restApi.text),
                            url: name.text,
                            withLoading: true,
                            config: RequestApiHelperData(
                              debug: false,
                              onTimeout: (data) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(data.body)['message'])));
                              },
                              body: bodys,
                              onSuccess: (data) {
                                response = data.toString();
                                setState(() {});
                              },
                            ),
                          );
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'You are done? Send it',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: card(
                child: Column(
                  children: [
                    Text(response),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
