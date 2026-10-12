// 第六部分必做：可运行的改造前后对照，非选做线性化实验。
import 'package:dart_oo/dart_oo.dart';

// 改造前：为了复用一行日志，成绩册必须继承日志基类。
class LoggingBase {
  void log(String message) => print('[$runtimeType] $message');
}

class GradeBookBefore extends LoggingBase {
  final List<Student> students;
  GradeBookBefore(List<Student> students) : students = List.of(students);
}

// 改造后：实际 GradeBook 使用 with Logger，移除了日志继承层。
void main() {
  final students = [Student('01', '李华', 92)];
  GradeBookBefore(students).log('改造前：继承日志基类');
  GradeBook(students).log('改造后：混入 Logger');
}
