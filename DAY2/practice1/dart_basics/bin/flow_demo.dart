// 流程控制示例合集
// 覆盖：gradeOf 分级器（if-else if-else）、for-in 循环、switch

// 1. gradeOf 分级器：分数 -> 等级
String gradeOf(int score) {
  if (score >= 90) {
    return 'A';
  } else if (score >= 80) {
    return 'B';
  } else if (score >= 70) {
    return 'C';
  } else if (score >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}

// 2. for-in 循环：遍历集合
void forInDemo() {
  var subjects = ['数学', '英语', '物理'];
  print('[for-in] 科目列表：');
  for (var s in subjects) {
    print('  - $s');
  }

  // for-in + 字符串插值
  var scores = {'数学': 88, '英语': 95, '物理': 72};
  print('[for-in] 成绩单：');
  for (var entry in scores.entries) {
    print('  ${entry.key}: ${entry.value} -> ${gradeOf(entry.value)}');
  }
}

// 3. 综合调用入口
void flowDemo() {
  print('[gradeOf] 95 -> ${gradeOf(95)}');
  print('[gradeOf] 82 -> ${gradeOf(82)}');
  print('[gradeOf] 50 -> ${gradeOf(50)}');
  forInDemo();
}
