import 'package:flutter/material.dart';

import '../template/body.dart';

class FeaturesView extends StatefulWidget {
  const FeaturesView({Key? key}) : super(key: key);

  @override
  State<FeaturesView> createState() => _FeaturesViewState();
}

class _FeaturesViewState extends State<FeaturesView> {
  String savingToken = """onSuccess(data) async {
    await Session.save(header:'token' ,stringData:data['your_token']);
  }""";

  String loading = """// in main.dart after WidgetsFlutterBinding.ensureInitialized()
Loading.widget = (context) async {
    await showDialog(
        barrierColor: Colors.black12,
        context: context,
        builder: (context) {
            Loading.currentContext = context;
            Loading.lastContext = context;
            return const LoadingView();
        },
    );
Loading.currentContext = context;
}""";

  String upload = """file: FileData(
    path: ['path_file_1','path_file_2','path_file_3'], 
    requestName: ['images[0]','images[1]','images[3]'],
)""";

  String customUrl = """RequestApiHelper.sendRequest(
    type: Api.get,
    url: '',
    config: RequestApiHelperData(
        baseUrl: 'yourNextPage',
        onSuccess: (data) {
            // process new data
            setState(() {});
        },
    ),
)""";
  List<bool> statusCopy = [false, false, false, false];
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
              'Saving Token',
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
              status: statusCopy[0],
              copyText: savingToken,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      savingToken,
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
              'showing Loading',
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
              copyText: loading,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      loading,
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
              'Uploading',
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
              copyText: upload,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      upload,
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
              'Custom Server Url',
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
              status: statusCopy[3],
              copyText: customUrl,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Text(
                      customUrl,
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
