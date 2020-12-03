import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

abstract class BaseCmd extends Command {
  BaseCmd() {
    buildArgs(argParser);
  }

  @override
  FutureOr<bool> run() {
    excute();
    return true;
  }

  void buildArgs(ArgParser argParser);

  void excute();

  bool getBool(String key, {bool defaultValue = false}) =>
      argResults.getBool(key, defaultValue: defaultValue);

  String getString(String key, {String defaultValue = ''}) =>
      argResults.getString(key, defaultValue: defaultValue);
}

extension Args on ArgResults {
  String getString(String key, {String defaultValue = ''}) {
    final value = this[key];
    return value ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    return value ?? defaultValue;
  }
}
