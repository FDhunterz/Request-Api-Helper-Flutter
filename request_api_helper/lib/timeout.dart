import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  final onSubmit;
  final onDissmiss;
  final Color buttonColor;

  Connection({this.onSubmit, this.onDissmiss, required this.buttonColor});
  @override
  _Connection createState() => _Connection();
}

class _Connection extends State<Connection> {
  @override
  void dispose() async {
    super.dispose();
    if (widget.onDissmiss != null) {
      await widget.onDissmiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 230,
            // color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset('packages/request_api_helper/assets/image/plug/plug.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'CONNECTION LOST',
              style: Theme.of(context).textTheme.headline1 ?? TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Check Your Internet Connection',
              style: Theme.of(context).textTheme.caption ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (widget.onSubmit != null) {
                await widget.onSubmit();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              primary: widget.buttonColor,
              textStyle: Theme.of(context).textTheme.button ??
                  TextStyle(
                    color: Colors.white,
                  ),
            ),
            child: Text(
              '             Reconnect            ',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

class Timeout extends StatefulWidget {
  final onSubmit;
  final onDissmiss;
  final Color buttonColor;

  Timeout({this.onSubmit, this.onDissmiss, required this.buttonColor});
  @override
  _Timeout createState() => _Timeout();
}

class _Timeout extends State<Timeout> {
  @override
  void dispose() async {
    super.dispose();
    if (widget.onDissmiss != null) {
      await widget.onDissmiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 230,
            // color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset('packages/request_api_helper/assets/image/worldwide/worldwide.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'REQUEST TIMEOUT',
              style: Theme.of(context).textTheme.headline1 ?? TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Maybe Server Is Down',
              style: Theme.of(context).textTheme.caption ??
                  TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (widget.onSubmit != null) {
                await widget.onSubmit();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              primary: widget.buttonColor,
              textStyle: Theme.of(context).textTheme.button ??
                  TextStyle(
                    color: Colors.white,
                  ),
            ),
            child: Text(
              '             Back            ',
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
