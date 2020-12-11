import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import 'configs.dart';
import 'ding.dart';

///
///上传到蒲公英
///
class Pgyer {
  ///
  ///上传到蒲公英
  ///
  static void upload(FileSystemEntity apk, String msg) async {
    final url = 'https://upload.pgyer.com/apiv1/app/upload';

    final apkName = path.basename(apk.path);
    final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
    final formData = FormData.fromMap({
      'uKey': 'f94f98b0b679b3c0dc92d6bb992669dd',
      '_api_key': '0f83d3377d21ca08f94d96b413dfeae2',
      'installType': 1,
      'updateDescription': msg,
      'file': filePart,
    });

    try {
      final result = await Dio().post(url, data: formData);
      print(result);
      final map = parseJson(result.toString());
      post(map, apkName, msg);
    } on Exception catch (e) {
      print('APK上传失败:$e');
    }
  }

  static Map parseJson(json) {
    final map = {};
    JsonDecoder((Object key, Object value) {
      map[key] = value;
      return value;
    }).convert(json);
    return map;
  }

  ///
  ///发送钉钉机器人消息
  ///
  static void post(Map map, String apkName, String msg) {
    final configs = Configs.read();
    final token = configs['token'];
    final qrcode = map['appQRCodeURL'] as String;
    final shortUrl = map['appShortcutUrl'] as String;
    final apkUrl = 'https://www.pgyer.com/$shortUrl';
    postDing(token, buildMarkdown(qrcode, apkName, apkUrl, msg));
  }
}
