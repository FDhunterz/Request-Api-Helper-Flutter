import 'package:example/example/attributes.dart';
import 'package:example/example/import.dart';
import 'package:example/example/request.dart';
import 'package:example/navigator/animation.dart';
import 'package:flutter/material.dart';
import 'package:request_api_helper/session.dart';

import '../template/body.dart';
import 'downloader.dart';
import 'features.dart';
import 'get.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  String materialAppText = """navigatorKey: navigatorKey,""";
  List<bool> statusCopy = [false, false, false];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      print(await Session.load('testing'));
    });
  }

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
              '1. Setup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                        Navigator.push(context, fadeIn(page: const ImportView()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'First Setting',
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              '2. Make First Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                        Navigator.push(context, fadeIn(page: const RequestViewTutorial()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'Get | Post | Put | Get in 1 code',
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              '3. All Atributes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                        Navigator.push(context, fadeIn(page: const RequestAttributesView()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'All atributes in Library',
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              '4. Features',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                        Navigator.push(context, fadeIn(page: const FeaturesView()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'Additional Features',
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Example',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                        Navigator.push(context, fadeIn(page: const RequestView()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'Check Example',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                        Future.delayed(Duration.zero, () async {
                          await Session.save(header: 'testing', stringData: '1 dulu');
                        });
                        Navigator.push(context, fadeIn(page: const DownloadView()));
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          'Download Example',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
