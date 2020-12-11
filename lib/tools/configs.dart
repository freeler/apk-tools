import 'dart:io';

///
///本地服务器配置
///
class Configs {
  ///
  ///配置文件
  ///
  static final file = File('C:\\Users\\Administrator\\apktool_configs');

  ///
  ///修改配置
  ///
  static void edit(String key, String value) {
    if (value != null) {
      final configs = read();
      configs[key] = value;
      write(configs);
      stdout.write('Succeed!');
    }
  }

  ///
  ///读配置
  ///
  static Map read() {
    final map = {};
    if (file.existsSync()) {
      final lines = file.readAsLinesSync();
      lines.forEach((element) {
        final e = element.split('=');
        final key = e[0].trim();
        final value = e[1].trim();
        map[key] = value;
      });
    }
    if (map.isEmpty) {
      writeEmptyConfigs();
    }
    return map;
  }

  ///
  ///写配置
  ///
  static void write(Map configs) {
    file.writeAsStringSync('');
    configs.forEach((key, value) {
      final line = '$key=$value\n';
      file.append(line);
    });
  }

  ///
  ///未配置前，写一个空配置文件,并提示
  ///
  static void writeEmptyConfigs() {
    Configs.write({'web': '', 'host': '', 'qrcode': '', 'token': ''});
    //提示
    stderr.write('''

     Your web server configs should be set when first run.
     run 'apk config --help' for available options.
     run 'apk config -v' to list the configs.
     Or you can also create a new file named 'C:\\Users\\Administrator\\apktool_configs' to set the configs.
     ''');
  }
}

extension FileWrite on File {
  File append(String content) {
    writeAsStringSync(content, mode: FileMode.append, flush: true);
    return this;
  }
}
