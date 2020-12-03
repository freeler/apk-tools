import 'package:apk/tools/configs.dart';
import 'package:args/args.dart';

import 'cmd_base.dart';

class ConfigCmd extends BaseCmd {
  @override
  String get name => 'config';

  @override
  String get description => 'config environment';

  @override
  void buildArgs(ArgParser argParser) {
    //钉钉机器人Token
    argParser.addOption(
      'token',
      abbr: 't',
      help: 'The DingTalk robot token',
    );
    //二维码地址
    argParser.addOption(
      'qrcode',
      abbr: 'q',
      help: 'The QR code of apk url',
    );
    //web服务器路径
    argParser.addOption(
      'web',
      abbr: 'w',
      help: 'The web directory of your server',
    );
    //主机地址
    argParser.addOption(
      'host',
      abbr: 'i',
      help: 'The web host of your server',
    );
    //打印配置信息
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'List configs',
    );
  }

  @override
  void excute() {
    ///从文件读配置
    final configs = Configs.read();
    if (configs.isEmpty) {
      ///没有配置信息时,自动写入空配置并提示
      return;
    }

    ///打印配置信息
    if (getBool('verbose')) {
      printConfigs();
      return;
    }

    ///修改配置
    if (argResults.arguments.isNotEmpty) {
      Configs.edit('host', argResults['host']);
      Configs.edit('web', argResults['web']);
      Configs.edit('qrcode', argResults['qrcode']);
      Configs.edit('token', argResults['token']);
      printConfigs();
    }
  }

  ///
  ///打印配置信息
  ///
  void printConfigs() {
    print(
        '\n****************************** CONFIGS ******************************');
    Configs.read().forEach((key, value) {
      print('$key=$value');
    });
  }
}
