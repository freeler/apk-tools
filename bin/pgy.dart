import 'dart:io';

import 'package:apk/tools/pgyer.dart';
import 'package:path/path.dart' as path;

///
///上传到蒲公英，并发送钉钉消息
///
void main(List<String> args) async {
  final msg = args.isEmpty ? '' : args.first;

  final files = await Directory('./').list(
    recursive: true, //递归到子目录
    followLinks: false, //不包含链接
  );
  final apk =
      await files.firstWhere((file) => path.extension(file.path) == '.apk');

  Pgyer.upload(apk, msg);
}
