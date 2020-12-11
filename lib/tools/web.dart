import 'dart:io';

import 'package:path/path.dart' as path;

import 'configs.dart';
import 'ding.dart';

///
///本地服务器
///
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
    postDing(token, buildMarkdown(qrcode, apkName, apkUrl, msg));
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
}
