import 'student.dart';

/// 成绩册保存列表副本，避免调用方增删原列表影响成绩册。
class GradeBook {
  final List<Student> _students;

  GradeBook(List<Student> students) : _students = List.of(students);

  List<Student> get students => List.unmodifiable(_students);
}
