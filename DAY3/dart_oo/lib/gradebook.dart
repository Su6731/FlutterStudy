import 'student.dart';

/// 成绩册保存列表副本，避免调用方增删原列表影响成绩册。
class GradeBook {
  final List<Student> _students;

  GradeBook(List<Student> students) : _students = List.of(students);

  List<Student> get students => List.unmodifiable(_students);

  double get average => _students.isEmpty
      ? 0
      : _students.fold<double>(0, (sum, student) => sum + student.score) /
            _students.length;

  /// 空成绩册没有最高分学生；同分时保留列表中的第一位。
  Student? get maxBy => _students.isEmpty
      ? null
      : _students.reduce((best, next) => next.score > best.score ? next : best);

  int get countPassed => _students.where((student) => student.passed).length;

  Map<String, List<Student>> get groupByGrade => _students.fold(
    <String, List<Student>>{'优': [], '良': [], '中': [], '不及格': []},
    (groups, student) {
      groups[student.grade]!.add(student);
      return groups;
    },
  );

  /// where → toList → sort → map → toList → asMap → map。
  /// 先复制再排序，不改变成绩册原有顺序。
  Map<int, String> get passedRanking =>
      (_students.where((student) => student.passed).toList()
            ..sort((a, b) => b.score.compareTo(a.score)))
          .map((student) => '${student.name}（${student.score} 分）')
          .toList()
          .asMap()
          .map((index, label) => MapEntry(index + 1, label));
}
