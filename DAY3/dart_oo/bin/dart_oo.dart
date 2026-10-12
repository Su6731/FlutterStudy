import 'package:dart_oo/dart_oo.dart';

void main(List<String> arguments) {
  final book = GradeBook([
    Student('01', '李华', 92),
    Student.fromJson({'id': '02', 'name': '王芳', 'score': 55}),
  ]);
  print(book.students);
}
