import 'package:flutter/material.dart';

import '../template/body.dart';

class RequestAttributesView extends StatefulWidget {
  const RequestAttributesView({Key? key}) : super(key: key);

  @override
  State<RequestAttributesView> createState() => _RequestAttributesViewState();
}

class _RequestAttributesViewState extends State<RequestAttributesView> {
  String sendRequestText = """String? url
required Api type,
RequestApiHelperData? config,
int? replacementId,
bool runInBackground = false,
Function(int uploaded, int total)? onUploadProgress,
bool withLoading = false""";

  String copyAttributes = """url:null,
type: Api.post || Api.get || Api.put || Api.delete,
config: RequestApiHelperData(),
replacementId: 1,
runInBackground: false,
withLoading: false,
onUploadProgress: (upload,total){
  print((upload/total) * 100);
},
""";

  String mainDartText = """String? baseUrl;
Map<String, dynamic>? body;
Map<String, String>? header;
bool bodyIsJson = false;
Function(dynamic)? onSuccess;
Function(Response)? onError;
Function(BuildContext)? onAuthError;
Function(Response)? onTimeout;
GlobalKey<NavigatorState>? navigatorKey;
bool? debug;
FileData? file;
Duration? timeout;""";

  String copyAttributesData = """baseUrl:null,
body: {},
header: null,
bodyIsJson: false,
onSuccess: (data){},
onError: (Response data){},
onAuthError: (context){},
onTimeout: (Response data){},
navigatorKey: navigatorKey,
debug: !kReleaseMode,
file: null,
timeout: Duration(seconds:60),
""";
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
              'RequestApiHelper.sendRequest{attributes}',
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
              copyText: copyAttributes,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      sendRequestText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'RequestApiHelperData',
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
              status: statusCopy[2],
              copyText: copyAttributesData,
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
