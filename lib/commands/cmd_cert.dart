import 'package:apk/global.dart';
import 'package:args/args.dart';

import 'cmd_base.dart';

class CertCmd extends BaseCmd {
  @override
  String get description => 'print apk cert infomation';

  @override
  String get name => 'printcert';

  @override
  void buildArgs(ArgParser argParser) {}

  @override
  void excute() async {
    final args = argResults.arguments;

    if (args == null || args.isEmpty || args.length > 1) {
      printHelpInfo();
      return;
    }
    final file = args[0];
    if (!file.endsWith('.apk')) {
      printHelpInfo();
      return;
    }

    final result =
        await shell('./', 'keytool -list -printcert -jarfile ${file}');
    print(result);
    final startIndex = result.indexOf('MD5:') + 6;
    final endIndex = startIndex + 48;
    final cert = result.substring(startIndex, endIndex).replaceAll(':', '');
    print('cert: $cert\n');
  }

  void printHelpInfo() {
    print('\ncert [apk file],打印APK签名信息\n');
  }
}
