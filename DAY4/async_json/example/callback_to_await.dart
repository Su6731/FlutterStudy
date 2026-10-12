// 自编嵌套回调示例：课程页面未附原程序，不冒充教师给定源码。
import 'dart:io';

import 'package:async_json/async_json.dart';

Future<String> buildReportWithCallbacks(String filePath) {
  return File(filePath).readAsString().then((text) {
    return Future.sync(() => parseBooks(text)).then((books) {
      return Future.sync(() => summarize(books)).then((report) {
        return report;
      });
    });
  });
}

// 与嵌套 then 对应的顺序 await 版；逐步等待并保留错误传播。
Future<String> buildReportWithAwait(String filePath) async {
  final text = await File(filePath).readAsString();
  final books = await Future.sync(() => parseBooks(text));
  final report = await Future.sync(() => summarize(books));
  return report;
}

Future<void> main() async {
  try {
    final before = await buildReportWithCallbacks(defaultDataPath);
    final after = await buildReportWithAwait(defaultDataPath);
    print('嵌套回调版与 await 版输出一致：${before == after}');
    print(after);
  } on FileSystemException {
    print('数据文件读取失败，请检查 data/books.json');
    exitCode = 1;
  } on FormatException catch (error) {
    print('JSON 数据错误：${error.message}');
    exitCode = 1;
  } catch (error) {
    print('处理失败：${error.runtimeType}');
    exitCode = 1;
  }
}
