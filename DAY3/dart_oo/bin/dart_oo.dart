import 'package:dart_oo/dart_oo.dart';

void main(List<String> arguments) {
  final book = GradeBook([
    Student('01', '李华', 92),
    Student.fromJson({'id': '02', 'name': '王芳', 'score': 55}),
    Student('03', '张伟', 85),
    Student('04', '赵敏', 73),
    Student('05', '陈晨', 60),
  ]);
  book.log('开始统计课程成绩册，共 ${book.students.length} 人');
  print(book.students);
  print('平均分：${book.average.toStringAsFixed(2)}');
  print('最高分：${book.maxBy}');
  print('及格人数：${book.countPassed}');
  book.groupByGrade.forEach((grade, students) {
    print('$grade：${students.map((student) => student.name).join('、')}');
  });
  print('及格学生排名：${book.passedRanking}');
}
