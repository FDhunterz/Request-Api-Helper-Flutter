import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:request_checker/request.dart' as req;
import 'package:request_checker/session.dart';

import 'model/config_model.dart';
import 'model/redirect_helper.dart';

void main() {
  RequestApiHelperConfig.save(RequestApiHelperConfigData(
    url: 'https://public.scool.my.id/api/',
    noapiurl: 'https://public.scool.my.id/',
    // url: 'http://192.168.100.200/scool_remake_2/public/api/',
    // noapiurl: 'http://192.168.100.200/scool_remake_2/public/',
    logResponse: true,
    exception: true,
    onException: (e) {
      print(e);
    },
    timeout: Duration(seconds: 30),
    version: '1.0.0',
    withLoading: Redirects(toogle: true),
    timeoutMessage: 'Timeout, Check Your Connection',
    // successMessage: 'default',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Silver VTR',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: MyHomePage(),
      // home: Topup(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getData() async {
    await Session.save('token', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOGJjMTMxZTYyMWQwOGNlODBkZTcyNGMxZjc3ZDNhNDdkZmVkOGM1YmZhZTc1ZjJiNTk0YTAxMzg1ZmI2YWZkY2I3NzhlMjkyMTUwMjk3YWYiLCJpYXQiOjE2MzE4MDMzMjUuMDY3NTIzMDAyNjI0NTExNzE4NzUsIm5iZiI6MTYzMTgwMzMyNS4wNjc1Mjk5MTY3NjMzMDU2NjQwNjI1LCJleHAiOjE2NjMzMzkzMjUuMDU3MDU5MDQ5NjA2MzIzMjQyMTg3NSwic3ViIjoiMiIsInNjb3BlcyI6W119.Fb_qt8seHTeRTC64k2tIwKpqB42wyQTb0JT5RzNG2DnuDOlGAUzs0W3X1rogyRbkTE6FdBD1VSAqgKOQElJXTcUpkkzS3EsEKEQJXTQJJwflcPrt7wH_rm1653Dm2hMJL4eLXBsH5Sk3FHZGcesaAGlKx1TVs2b_kAe8rSa3ugU_x_GOV4qryq52ZMxpINz9iev1ylFyWJ_e4ttvkpGfA7AkuUT3RtgJWMn2GbI00rjwzldyrAz21SoImH94HPZHtudjE0dJ3T2E0kVQ5InbKv7_fCP7-qmKeMkSrfL2arkKhgjOVFgdRAu4w_iJV4lvyfrNeDqLX52vgcFnLAM6MtX9d_oSpvQFS5GxABjLwEeFThrtMbcgDhduD8q8xdf1hLKdrb4n4_GKXhoFsfzDmy2zH5p-aZCgEw7Lq96h5YxAwphC5SWItnSeZP1T7EqxAGfMhfP_x_E4Fd85KTgXYwZgBVmSLlEBJpgxQxUEVyLgJht1ashszyPz93fi-m1n8Yv4bdIp5Q2r7grHBVBDDY9r-EH_NFePBm-ixcpw4nW1gjJ2qX0pV-xPa5tjE5s059J041WSD1gdz3PLH_edts6QazuuQSpJNIWUaRb5BRN1vepkKHO2tP_fkRaR4GkCW1W-rPayOmCICGCWdmsvSy3i2mLqN16gmFdGwRh8o64');
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      req.send(
        type: RESTAPI.POST,
        name: 'tugas/upload',
        data: RequestData(
          file: RequestFileData(filePath: [image.path], fileRequestName: ['file[0]']),
          body: {
            'id_scool': 'eyJpdiI6IkFjaFBBTXNKYittZnB1ZVBaa29ZY3c9PSIsInZhbHVlIjoidEtVK2FyTlBQVHdvMFEvY0M4M0ZLZz09IiwibWFjIjoiZjQ3NzUyZjcyZTZlMzM0MzQxODNhYzA5ZDIxOGUxZjM0NWQwNTFmODU4M2U2ZTlkNjI0ODUxMTg2MDUyM2I1NyIsInRhZyI6IiJ9',
            'id_tugas': 'eyJpdiI6IjNwN21OaU5zcE1CeUoxdWVrazNJWnc9PSIsInZhbHVlIjoidmpMdC9yOFFUZ1pMVmw2NVZnOUxCdz09IiwibWFjIjoiYjkyNDhhYzhjZGVlNjZmYTI5MDM2NDFjMjI3MzUyMjljNGQ5MDYxMTNjYmM5NWUzY2NlZTM0NzU0NTc2YmQ1NSIsInRhZyI6IiJ9',
          },
        ),
        context: context,
        changeConfig: RequestApiHelperConfigData(
          onSuccess: (data) {},
          onError: (code, data) {},
        ),
        onUploadProgress: (sended, total) {
          print(sended / total * 100);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
      ),
    );
  }
}
