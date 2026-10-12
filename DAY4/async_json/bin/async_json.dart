import 'dart:io';

import 'package:async_json/async_json.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runCli(arguments);
}
