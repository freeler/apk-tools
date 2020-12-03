import 'package:apk/global.dart';

///
/// 打印APK签名信息
///
void main(List<String> args) async {
  if (args == null || args.isEmpty || args.length > 1) {
    printHelpInfo();
    return;
  }
  final file = args[0];
  if (!file.endsWith('.apk')) {
    printHelpInfo();
    return;
  }

  final result = await shell('./', 'keytool -list -printcert -jarfile ${file}');
  print(result);
  final startIndex = result.indexOf('MD5:') + 6;
  final endIndex = startIndex + 48;
  final cert = result.substring(startIndex, endIndex).replaceAll(':', '');
  print('cert: $cert\n');
}

void printHelpInfo() {
  print('\n命令格式: cert [apk file]               打印APK签名信息\n');
}
