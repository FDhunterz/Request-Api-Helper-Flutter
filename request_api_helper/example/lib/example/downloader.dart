import 'package:example/template/base_widget.dart';
import 'package:example/template/body.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

class DownloadTask {
  double progress;
  String? url, path;

  DownloadTask({this.path, this.progress = 0, this.url});
}

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final controller = TextEditingController(text: 'https://mediplus.s3.amazonaws.com/17918/zv49pcvbk4bjxkgwkept.jpg');
  double progress = 0;
  List<DownloadTask> listDownload = [];

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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listDownload.length,
              itemBuilder: (context, index) {
                final data = listDownload[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text((data.progress * 100).toStringAsFixed(1) + '%'),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(child: Text(data.path ?? '')),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: LinearProgressIndicator(
                          color: Colors.greenAccent,
                          value: data.progress,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                        onTap: () async {
                          Permission.storage.request();
                          progress = 0;
                          setState(() {});
                          listDownload.add(DownloadTask(url: controller.text));
                          final getLast = listDownload.last;
                          await RequestApiHelper.sendRequest(
                            type: Api.download,
                            url: controller.text,
                            onProgress: (current, total) {
                              try {
                                setState(() {
                                  getLast.progress = (current / total);
                                });
                              } catch (_) {}
                            },
                            config: RequestApiHelperDownloadData(
                              path: (await getExternalStorageDirectory())?.path,
                              onSuccess: (data) {
                                print(RequestApiHelper.log.length);
                                for (var i in RequestApiHelper.log) {
                                  print(i);
                                }
                                final datas = data as RequestApiHelperDownloader;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success')));
                                // print((RequestApiHelper.totalDataUsed / 1000).toString() + ' KB');
                                setState(() {
                                  getLast.path = datas.path;
                                  getLast.progress = 1;
                                });
                              },
                              onError: (data) {
                                listDownload.remove(getLast);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.body)));
                              },
                            ),
                          );
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Download Now',
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
      ),
    );
  }
}
