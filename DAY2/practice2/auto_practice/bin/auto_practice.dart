import 'null_safety_rewrite.dart';
import 'report_generator.dart';
import 'grade_ext.dart';

void main(List<String> arguments) {
  runNullSafetyRewrite();
  print('');
  runReportGenerator();
  print('');
  runGradeOfExt();
}
