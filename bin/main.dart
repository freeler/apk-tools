import 'package:apk/apk_runner.dart';
import 'package:apk/global.dart';
import 'package:args/command_runner.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('apk', 'apk tools');
  final apkRunner = ApkRunner(runner.argParser);

  if (arguments.isEmpty || commands.contains(arguments.first)) {
    runner.run(arguments);
  } else {
    apkRunner.run(arguments);
  }
}
