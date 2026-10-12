import 'dart:async';

import 'package:dart_oo/dart_oo.dart';
import 'package:test/test.dart';

void main() {
  test('正常成绩的统计、分档和排名正确，排序不改变原列表', () {
    final students = [
      Student('01', '李华', 92),
      Student.fromJson({'id': '02', 'name': '王芳', 'score': 55}),
      Student('03', '张伟', 85),
      Student('04', '赵敏', 73),
      Student('05', '陈晨', 60),
    ];
    final book = GradeBook(students);
    expect(book.average, 73);
    expect(book.maxBy, same(students.first));
    expect(book.countPassed, 4);
    expect(book.groupByGrade.map((key, value) => MapEntry(key, value.length)), {
      '优': 1,
      '良': 1,
      '中': 2,
      '不及格': 1,
    });
    expect(book.passedRanking, {
      1: '李华（92.0 分）',
      2: '张伟（85.0 分）',
      3: '赵敏（73.0 分）',
      4: '陈晨（60.0 分）',
    });
    expect(book.students.map((student) => student.id), [
      '01',
      '02',
      '03',
      '04',
      '05',
    ]);
    students.clear();
    expect(book.students, hasLength(5));
  });

  test('构造函数、JSON 和 setter 拒绝非法分数，失败后保留原值', () {
    final student = Student('01', '李华', 80);
    for (final invalid in [-1.0, 101.0, double.nan, double.infinity]) {
      expect(() => Student('02', '王芳', invalid), throwsArgumentError);
      expect(
        () => Student.fromJson({'id': '03', 'name': '张伟', 'score': invalid}),
        throwsArgumentError,
      );
      expect(() => student.score = invalid, throwsArgumentError);
      expect(student.score, 80);
    }
  });

  test('分档边界、整数 JSON 分数和 setter 更新', () {
    expect(
      [
        0.0,
        59.0,
        60.0,
        79.0,
        80.0,
        89.0,
        90.0,
        100.0,
      ].map((score) => Student('01', '测试', score).grade),
      ['不及格', '不及格', '中', '中', '良', '良', '优', '优'],
    );
    final student = Student.fromJson({'id': '01', 'name': '李华', 'score': 59});
    expect(student.passed, isFalse);
    student.score = 60;
    expect(student.passed, isTrue);
    expect(GradeBook([student]).average, 60);
  });

  test('空成绩册返回明确的空结果', () {
    final book = GradeBook([]);
    expect(book.average, 0);
    expect(book.maxBy, isNull);
    expect(book.countPassed, 0);
    expect(book.groupByGrade.values.every((group) => group.isEmpty), isTrue);
    expect(book.passedRanking, isEmpty);
  });

  test('最高分并列时返回第一位学生', () {
    final first = Student('01', '李华', 100);
    expect(GradeBook([first, Student('02', '王芳', 100)]).maxBy, same(first));
  });

  test('GradeBook 混入日志能力，输出包含类型和消息', () {
    final output = <String>[];
    runZoned(
      () => GradeBook([]).log('统计完成'),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => output.add(line),
      ),
    );
    expect(output, ['[GradeBook] 统计完成']);
  });
}
