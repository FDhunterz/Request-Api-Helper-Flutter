import 'package:example/navigator/animation.dart';
import 'package:flutter/material.dart';
import 'package:request_api_helper/request_api_helper.dart';
import 'example/navigation.dart';

class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4102d8),
              Color(0xff090451),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 200,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo,
                      blurRadius: 200,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: SizedBox(
                    width: 330,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0, left: 24, right: 24),
                      child: Center(
                        child: Image.asset('assets/images/background.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * .96,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: Colors.white.withOpacity(.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Request api helper V4',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'setting app',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'handling duplicate request',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Easy Upload',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Example',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Material(
                          color: const Color(0xffab2446),
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          child: InkWell(
                            splashColor: Colors.black12,
                            onTap: () async {
                              // await Session.save(header: 'header', boolData: true);
                              RequestApiHelper.to(route: fadeIn(page: const NavigationView()));
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child: Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
