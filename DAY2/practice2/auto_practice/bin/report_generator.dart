// 任务2：命名参数设计 —— 实验报告生成器
//
// 设计目标：覆盖 required 必填、默认值、可空可选 三种命名参数形态
// 字段语义：
//   - studentName/studentId/experimentName：必填，无合理默认值 → required
//   - experimentDate：可选，默认今天 → 可空 + 函数体内兜底 DateTime.now()
//   - advisor：可选指导老师 → 可空 String?，未指定显示"未指定"
//   - score：可空，可能尚未评分 → double? + 用 ?? 显示"未评分"
//   - durationHours：有合理默认值 2 小时 → 默认参数
//   - passed：可空 bool?，默认根据 score 推断 → 未传时按 >=60 判定

String generateReport({
  required String studentName,
  required String studentId,
  required String experimentName,
  DateTime? experimentDate,
  String? advisor,
  double? score,
  int durationHours = 2,
  bool? passed,
}) {
  final dateStr = (experimentDate ?? DateTime.now()).toString().substring(0, 10);
  final advisorStr = advisor ?? '未指定';
  final scoreStr = score == null ? '未评分' : score.toStringAsFixed(1);
  // passed 处理：显式传优先；未传时按分数推断；分数未评分则未通过
  final bool passedValue = passed ?? (score != null && score >= 60);

  final buffer = StringBuffer();
  buffer.writeln('================ 实验报告 ================');
  buffer.writeln('学生姓名 : $studentName');
  buffer.writeln('学号     : $studentId');
  buffer.writeln('实验名称 : $experimentName');
  buffer.writeln('实验日期 : $dateStr');
  buffer.writeln('指导老师 : $advisorStr');
  buffer.writeln('实验时长 : ${durationHours}h');
  buffer.writeln('得分     : $scoreStr');
  buffer.writeln('是否通过 : ${passedValue ? "是" : "否"}');
  buffer.writeln('==========================================');
  return buffer.toString();
}

// 三种调用演示：从最简 → 标准 → 完整
void runReportGenerator() {
  print('====== 任务2：命名参数三种调用 ======');

  // 调用1【最简】：仅传 required 必填参数，其余用默认/兜底
  print('-- 调用1（最简） --');
  print(generateReport(
    studentName: '张三',
    studentId: '2026001',
    experimentName: 'Dart 空安全基础',
  ));

  // 调用2【标准】：必填 + 部分默认参数覆盖（日期/时长）
  print('-- 调用2（标准） --');
  print(generateReport(
    studentName: '李四',
    studentId: '2026002',
    experimentName: '命名参数设计',
    experimentDate: DateTime(2026, 10, 8),
    durationHours: 3,
  ));

  // 调用3【完整】：所有参数显式指定（含 advisor / score / passed）
  print('-- 调用3（完整） --');
  print(generateReport(
    studentName: '王五',
    studentId: '2026003',
    experimentName: '成绩分级器扩展',
    experimentDate: DateTime(2026, 10, 8),
    advisor: '赵老师',
    score: 78.5,
    durationHours: 2,
    passed: true,           // 显式覆盖，无视 score 推断
  ));
}
