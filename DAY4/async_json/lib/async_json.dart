import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'book.dart';
export 'book.dart';

String get defaultDataPath => p.join('data', 'books.json');

List<Book> parseBooks(String text) => (jsonDecode(text) as List<dynamic>)
    .map((item) => Book.fromJson(item as Map<String, dynamic>))
    .toList();

Future<List<Book>> loadBooks(String filePath) async {
  final text = await File(filePath).readAsString();
  return parseBooks(text);
}

String summarize(List<Book> books) {
  final categories = books.fold(<String, int>{}, (counts, book) {
    counts.update(book.category, (count) => count + 1, ifAbsent: () => 1);
    return counts;
  });
  final ranked = [...books]..sort((a, b) {
    final comparison = b.borrowCount.compareTo(a.borrowCount);
    return comparison == 0 ? a.id.compareTo(b.id) : comparison;
  });
  final lines = <String>['图书总数：${books.length}'];
  categories.forEach((category, count) => lines.add('类目 $category：$count 本'));
  lines.add('借阅量 Top3：');
  ranked.take(3).toList().asMap().forEach((index, book) {
    lines.add('${index + 1}. ${book.title}（${book.category}）：${book.borrowCount} 次');
  });
  final roundtrip = parseBooks(jsonEncode(books.map((book) => book.toJson()).toList()));
  final consistent = jsonEncode(roundtrip.map((book) => book.toJson()).toList()) ==
      jsonEncode(books.map((book) => book.toJson()).toList());
  lines.add('模型 roundtrip 一致：$consistent');
  return lines.join('\n');
}
