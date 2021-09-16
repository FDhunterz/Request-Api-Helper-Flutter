import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:request_api_helper/request.dart' as req;
import 'package:request_api_helper/request_api_helper.dart';
import 'package:request_api_helper/session.dart';

void main() {
  test('adds one to input values', () async {
    await RequestApiHelperConfig.save(
      RequestApiHelperConfigData(
        url: 'https://public.scool.my.id/api/',
        noapiurl: 'https://public.scool.my.id/',
        logResponse: true,
        withLoading: Redirects(toogle: false),
      ),
    );
    var test = File('packages/request_api_helper/assets/image/worldwide/worldwide.png');
    print(test.path);
    await Session.save('token', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMWY4NmE2ZTdiMDA1MzEwMWJlYzMxNjg0MTM0OWYxYzVlNWQyNGZhYjg0NTEwOTlhNjkxMjIwMTI0MDMyNTIzNGNjZDk1ZjNmMGVkMWRhZjQiLCJpYXQiOjE2MzE4MDIzMDUuMDc1NDc0MDIzODE4OTY5NzI2NTYyNSwibmJmIjoxNjMxODAyMzA1LjA3NTQ4NTk0NDc0NzkyNDgwNDY4NzUsImV4cCI6MTY2MzMzODMwNS4wNjIwNjAxMTc3MjE1NTc2MTcxODc1LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.cC8TDmllS1sPp_aMn-h3xbKbEVPc71KP3t7PCIUnIUlCnaqbMX7_29gM1raNUpwYMwrCLDY4olFm3pDRWw8aLtIF3nSsiLpGNzZdxSvIO25Dclk_kuqtfsu_Sxc0n6wQEn0TCN5b75SL6mxaO28nKzHDLjUy0en8f930qTSppHMU8fzLJibaFTXEd5zKf95JDzlVBGpObOX-QxZe6mzDekSlQs1THUNEkJ_vBSXEKtJ6lO0_Tk4-7sSWzskG4yImSj_AStvwYd8JT1xo6EC2ZJA2n4L7qgvZTHCP_CCdo8nRvPps5w95vahM7W-zPfo6yomczvFtn5QSVleZyuyQKmbhhRboUC_EUkR5YMO1tCW4XaNQz9P3pyN6-BFiqh6GwQETSTqGTnBw2qtXtU7XeHSbK6lImKC_pDyQPcS_3dMk0kjBKA3u9TwCLABcBVDsNOu07K-l6rxEGL1ICUaWNKXfsbQ7g-F6_B2qeTc1x4-FqSsJI6NEN4t8184pZLH2iUZqdyYG9qIKpuI8Et7JPc4Rf3pLHUheibwLwwHF-mvAT8VxvWiRu9DTEbb7S_ApuOIseX3Qrrfd_PFiOOU_NJzTku506fe2K_FkCbJfZ2HeBHucfYgmd_I-bABrHbDqI7Loz2a76PznyvW');
    await req.send(
        name: 'tugas/upload',
        data: RequestData(
          file: RequestFileData(
            filePath: [test.path],
            fileRequestName: ['test'],
          ),
          body: {'null': 'null', 'version': '1.0.0'},
        ),
        type: RESTAPI.POST,
        changeConfig: RequestApiHelperConfigData(
          logResponse: true,
          onError: (code, data) {
            print(data);
          },
          onSuccess: (data) {},
          exception: true,
          onException: (string) {
            print(string);
          },
        ),
        onUploadProgress: (send, total) {
          print(send);
          print(total);
        });
  });
  // print('a');
}
