import 'dart:io';

import 'package:apk/commands/cmd_base.dart';
import 'package:apk/global.dart';
import 'package:apk/tools/pgyer.dart';
import 'package:args/src/arg_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shell/shell.dart';

class ApkRunner {
  final ArgParser argParser;

  ApkRunner(this.argParser) {
    //release apk
    argParser.addFlag(
      'release',
      abbr: 'r',
      negatable: false,
      help: 'Build a release version of your app.',
    );
    //debug apk 默认
    argParser.addFlag(
      'debug',
      abbr: 'd',
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

    ///参数
    final isRelease = args.getBool('release');
    final flavor = args.getString('flavor');
    final msg = args.getString('msg');
    final project = args.getString('path', defaultValue: './');
    print(project);

    //原生项目打包
    if (isNativeProject(project)) {
      buildNativeApk(project, isRelease, flavor).then(
        (apk) => Pgyer.upload(apk, msg),
      );
      return;
    }

    //Flutter项目打包
    if (isFlutterProject(project)) {
      buildFlutterApk(project, isRelease, flavor).then(
        (apk) => Pgyer.upload(apk, msg),
      );
      return;
    }

    // stderr.write('\nERROR:project directory path is required:-p <path>\n');
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
    final shell = Shell(workingDirectory: project);
    await shell.startAndReadAsString(
        './gradlew', ['clean']).then((value) => print(value));
    await shell.startAndReadAsString(
        './gradlew', ['assemble$flavor$type']).then((value) => print(value));
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
    final shell = Shell(workingDirectory: project);
    await shell.startAndReadAsString(
        'flutter', ['clean']).then((value) => print(value));
    await shell.startAndReadAsString('flutter', [
      'build',
      'apk',
      type,
      if (flavorArg.isNotEmpty) flavorArg,
    ]).then((value) => print(value));
    final dir = '${project}/build';
    final files = await Directory(dir).list(
      recursive: true, //递归到子目录
      followLinks: false, //不包含链接
    );
    return files.firstWhere((file) => path.extension(file.path) == '.apk');
  }

  bool isNativeProject(String project) {
    return File('$project/gradlew.bat').existsSync();
  }

  bool isFlutterProject(String project) {
    return File('$project/pubspec.yaml').existsSync();
  }
}
