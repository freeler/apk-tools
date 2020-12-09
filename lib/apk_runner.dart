import 'dart:io';

import 'package:apk/commands/cmd_base.dart';
import 'package:apk/global.dart';
import 'package:args/src/arg_parser.dart';
import 'package:path/path.dart' as path;

import 'tools/configs.dart';
import 'tools/web.dart';

class ApkRunner {
  final ArgParser argParser;

  ApkRunner(this.argParser) {
    //release apk
    argParser.addFlag(
      'release',
      negatable: false,
      help: 'Build a release version of your app.',
    );
    //debug apk 默认
    argParser.addFlag(
      'debug',
      negatable: false,
      help: 'Build a debug version of your app (default mode).',
    );
    //多渠道，指定渠道
    argParser.addOption(
      'flavor',
      abbr: 'f',
      help: 'Build a custom  flavor app.',
    );
    //项目路径
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Your project directory path',
    );
    //钉钉机器人消息
    argParser.addOption(
      'msg',
      abbr: 'm',
      help: 'The DingTalk robot message',
    );
  }

  void run(List<String> arguments) {
    final args = argParser.parse(arguments);
    if (args.getBool('help')) {
      print(argParser.usage);
      return;
    }

    //读配置
    final configs = Configs.read();
    if (configs.isEmpty) return;

    ///参数
    final isRelease = args.getBool('release');
    final flavor = args.getString('flavor');
    final msg = args.getString('msg');
    final project = args.getString('path', defaultValue: './');

    //原生项目打包
    if (isNativeProject(project)) {
      buildNativeApk(project, isRelease, flavor).then(
        (apk) => Web.publish(apk, msg),
      );
      return;
    }

    //Flutter项目打包
    if (isFlutterProject(project)) {
      buildFlutterApk(project, isRelease, flavor).then(
        (apk) => Web.publish(apk, msg),
      );
      return;
    }

    stderr.write('\nERROR:project directory path is required:-p <path>\n');
  }

  ///
  ///原生打包
  ///
  Future<FileSystemEntity> buildNativeApk(
    String project,
    bool isRelease,
    String flavor,
  ) async {
    final type = isRelease ? 'Release' : 'Debug';
    await shell(project, 'gradlew clean');
    await shell(project, 'gradlew assemble$flavor$type');

    final files = await Directory(project).list(
      recursive: true, //递归到子目录
      followLinks: false, //不包含链接
    );
    return files.firstWhere((file) => path.extension(file.path) == '.apk');
  }

  ///
  ///Flutter项目打包
  ///
  Future<FileSystemEntity> buildFlutterApk(
    String project,
    bool isRelease,
    String flavor,
  ) async {
    final type = isRelease ? '--release' : '--debug';
    final flavorArg = flavor.isEmpty ? '' : '--flavor $flavor';
    await shell(project, 'flutter clean');
    await shell(project, 'flutter build apk $type $flavorArg');

    final dir = '$project/build';
    final files = await Directory(dir).list(
      recursive: true, //递归到子目录
      followLinks: false, //不包含链接
    );
    return files.firstWhere((file) => path.extension(file.path) == '.apk');
  }

  bool isNativeProject(String project) {
    return File('$project\\gradlew.bat').existsSync();
  }

  bool isFlutterProject(String project) {
    return File('$project\\pubspec.yaml').existsSync();
  }
}
