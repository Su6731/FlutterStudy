import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'book.dart';
export 'book.dart';

String get defaultDataPath => p.join('data', 'books.json');

List<Book> parseBooks(String text, {void Function(String)? onWarning}) {
  final decoded = jsonDecode(text);
  if (decoded is! List) throw FormatException('JSON 类型错误：顶层必须是数组');
  return decoded.asMap().entries.map((entry) {
    final item = entry.value;
    if (item is! Map<String, dynamic>) {
      throw FormatException('JSON 类型错误：第 ${entry.key + 1} 项必须是对象');
    }
    return Book.fromJson(item, onWarning: onWarning);
  }).toList();
}

Future<List<Book>> loadBooks(
  String filePath, {
  void Function(String)? onWarning,
}) async {
  final text = await File(filePath).readAsString();
  return parseBooks(text, onWarning: onWarning);
}

/// 顺序 await 版：读取完成后才解析并统计。
Future<String> buildReport(
  String filePath, {
  void Function(String)? onWarning,
}) async {
  final books = await loadBooks(filePath, onWarning: onWarning);
  return summarize(books);
}

/// 将外部错误转换为可读消息，返回码供控制台或测试使用。
Future<int> runCli(
  List<String> arguments, {
  void Function(String)? output,
}) async {
  final emit = output ?? print;
  if (arguments.length > 1) {
    emit('用法：dart run bin/async_json.dart [JSON文件路径]');
    return 64;
  }
  final filePath = arguments.isEmpty ? defaultDataPath : arguments.single;
  try {
    emit(await buildReport(filePath, onWarning: emit));
    return 0;
  } on FileSystemException catch (error) {
    if (error.osError?.errorCode == 2 || error.osError?.errorCode == 3) {
      emit('数据文件缺失，请检查 ${p.posix.joinAll(p.split(filePath))}');
    } else {
      emit('数据文件读取失败，请检查路径、权限及文件编码：$filePath');
    }
    return 1;
  } on FormatException catch (error) {
    emit('JSON 数据错误：${error.message}');
    return 1;
  } catch (error) {
    emit('处理失败，请检查数据或运行环境（${error.runtimeType}）');
    return 1;
  }
}

String summarize(List<Book> books) {
  final categories = books.fold(<String, int>{}, (counts, book) {
    counts.update(book.category, (count) => count + 1, ifAbsent: () => 1);
    return counts;
  });
  final ranked = [...books]
    ..sort((a, b) {
      final comparison = b.borrowCount.compareTo(a.borrowCount);
      return comparison == 0 ? a.id.compareTo(b.id) : comparison;
    });
  final lines = <String>['图书总数：${books.length}'];
  categories.forEach((category, count) => lines.add('类目 $category：$count 本'));
  lines.add('借阅量 Top3：');
  ranked.take(3).toList().asMap().forEach((index, book) {
    lines.add(
      '${index + 1}. ${book.title}（${book.category}）：${book.borrowCount} 次',
    );
  });
  final roundtrip = parseBooks(
    jsonEncode(books.map((book) => book.toJson()).toList()),
  );
  final consistent =
      jsonEncode(roundtrip.map((book) => book.toJson()).toList()) ==
      jsonEncode(books.map((book) => book.toJson()).toList());
  lines.add('模型 roundtrip 一致：$consistent');
  return lines.join('\n');
}
