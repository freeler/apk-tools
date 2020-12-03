import 'dart:io';

///
///运行命令，并打印结果
///
Future<String> shell(String workingDir, String cmd) async {
  final result = await Process.run(
    cmd,
    [],
    runInShell: true,
    workingDirectory: workingDir,
  );
  final msg = result.stdout.toString();
  print(msg);
  return msg;
}

final commands = [
  'cert',
  'config',
  'printcert',
];
