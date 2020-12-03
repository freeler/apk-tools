import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'configs.dart';

class Web {
  static void publish(FileSystemEntity apk, String msg) {
    if (apk == null) {
      print('Build Failed:APK not found!');
      return;
    }
    final configs = Configs.read();
    final web = configs['web'];
    final host = configs['host'];
    final qrcode = configs['qrcode'];
    final token = configs['token'];

    final apkName = path.basename(apk.path);
    //将APK复制到Web目录
    apk.rename('$web\\apk\\$apkName');
    //生成APK链接
    final apkUrl = '$host/apk/$apkName';
    //生成index.html
    genHtml(web, apkUrl);
    //发送钉钉机器人消息
    post(token, buildMarkdown(qrcode, apkName, apkUrl, msg));
  }

  static String buildMarkdown(
    String qrcode,
    String apkName,
    String apkUrl,
    String msg,
  ) {
    return '''
  ![](${qrcode})    
  APK：[$apkName]($apkUrl)    
  更新内容：$msg    
  ''';
  }

  ///
  ///生成html
  ///
  static void genHtml(String web, String url) {
    final file = File('$web/download.html');
    if (!file.existsSync()) file.create();
    final contents = '''
  <!DOCTYPE html>
  <head>
  <script>
  window.location.href = '$url';
  </script>
  </head>
  </html>
  ''';
    file.writeAsString(contents);
  }

  ///
  ///发送消息到钉钉
  ///
  static void post(String token, String markdown) async {
    final params = {
      'msgtype': 'markdown',
      'markdown': {
        'title': 'Android APK',
        'text': markdown,
      }
    };

    final client = HttpClient();
    final url = 'https://oapi.dingtalk.com/robot/send?access_token=$token';
    final request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(params)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    print(responseBody.toString());
  }
}
