import 'dart:convert';
import 'dart:io';

import 'package:async_json/async_json.dart';
import 'package:test/test.dart';

import '../example/callback_to_await.dart' as rewrite;

void main() {
  test('演示数据统计正确，排序不修改原集合', () async {
    final books = await loadBooks(defaultDataPath);
    final report = summarize(books);
    expect(books, hasLength(6));
    expect(report, contains('类目 编程：2 本'));
    expect(report, contains('类目 科学：2 本'));
    expect(report, contains('类目 文学：2 本'));
    expect(report, contains('1. Flutter 实践（编程）：45 次'));
    expect(report, contains('2. 散文选读（文学）：32 次'));
    expect(report, contains('3. Dart 入门（编程）：28 次'));
    expect(books.first.id, 'B001');
  });

  test('完整数据 fromJson/toJson 往返保持一致', () async {
    final original = jsonDecode(await File(defaultDataPath).readAsString());
    final books = await loadBooks(defaultDataPath);
    expect(
      jsonDecode(jsonEncode(books.map((book) => book.toJson()).toList())),
      original,
    );
    expect(
      parseBooks('[{"id":"1","title":"书","category":"类","borrowCount":2.0}]')
          .single
          .borrowCount,
      2,
    );
  });

  test('借阅字段缺失或 null 默认 0 并发出友好警告', () async {
    final messages = <String>[];
    final books = await loadBooks(
      'test/fixtures/missing_field.json',
      onWarning: messages.add,
    );
    expect(books.single.borrowCount, 0);
    expect(messages.single, contains('已使用默认值 0'));
    expect(
      Book.fromJson({
        'id': '1',
        'title': '书',
        'category': '类',
        'borrowCount': null,
      }).borrowCount,
      0,
    );
  });

  test('必填字段缺失及字段类型错误给出字段名', () {
    expect(
      () => Book.fromJson({'id': '1', 'category': '类'}),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('title'),
        ),
      ),
    );
    expect(
      () => Book.fromJson({'id': 1, 'title': '书', 'category': '类'}),
      throwsFormatException,
    );
    for (final value in ['很多', -1, 1.5, true, double.infinity]) {
      expect(
        () => Book.fromJson({
          'id': '1',
          'title': '书',
          'category': '类',
          'borrowCount': value,
        }),
        throwsFormatException,
      );
    }
  });

  test('无效 JSON、错误顶层和错误元素被拒绝', () {
    expect(() => parseBooks('{'), throwsFormatException);
    expect(() => parseBooks('{}'), throwsFormatException);
    expect(() => parseBooks('[null]'), throwsFormatException);
    expect(() => parseBooks('[1]'), throwsFormatException);
  });

  test('文件缺失返回非零状态和友好提示，不抛堆栈', () async {
    final output = <String>[];
    expect(
      await runCli(['test/fixtures/does-not-exist.json'], output: output.add),
      1,
    );
    expect(output.single, '数据文件缺失，请检查 test/fixtures/does-not-exist.json');
  });

  test('控制台类型错误兜底、缺失字段警告及正常返回', () async {
    final output = <String>[];
    expect(
      await runCli(['test/fixtures/wrong_type.json'], output: output.add),
      1,
    );
    expect(output.single, contains('borrowCount 必须是非负整数'));
    output.clear();
    expect(
      await runCli(['test/fixtures/missing_field.json'], output: output.add),
      0,
    );
    expect(output.first, contains('已使用默认值 0'));
    expect(output.last, contains('图书总数：1'));
    expect(await runCli([], output: (_) {}), 0);
    expect(await runCli(['a', 'b'], output: (_) {}), 64);
  });

  test('回调改写前后正常结果及异步异常传播一致', () async {
    expect(
      await rewrite.buildReportWithCallbacks(defaultDataPath),
      await rewrite.buildReportWithAwait(defaultDataPath),
    );
    expect(
      await buildReport(defaultDataPath),
      await rewrite.buildReportWithAwait(defaultDataPath),
    );
    await expectLater(
      rewrite.buildReportWithCallbacks('no-such-file.json'),
      throwsA(isA<FileSystemException>()),
    );
    await expectLater(
      rewrite.buildReportWithAwait('no-such-file.json'),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('空数组与不足三本不会越界', () {
    expect(summarize([]), contains('图书总数：0'));
    final single = Book(id: '1', title: '单本', category: '类', borrowCount: 0);
    expect(summarize([single]), contains('1. 单本（类）：0 次'));
    expect(summarize([single]), isNot(contains('2.')));
  });
}
