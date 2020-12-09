import 'dart:io';

///
///运行命令，并打印结果
///
Future<String> shell(String workingDir, String cmd) async {
  final result = await runShell(workingDir, cmd);
  final msg = result.stdout.toString();
  print(msg);
  return msg;
}

///
///运行命令，并打印结果
///
Future<ProcessResult> runShell(String workingDir, String cmd) async {
  return await Process.run(
    cmd,
    [],
    runInShell: true,
    workingDirectory: workingDir,
  );
}

final commands = [
  '--help',
  '-h',
  'cert',
  'cert',
  'config',
  'printcert',
];
