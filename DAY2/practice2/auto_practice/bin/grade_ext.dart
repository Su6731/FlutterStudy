// 任务3：控制流小程序 —— 成绩分级器扩展
//
// 扩展点：
// 1. 边界 100：满分仍属于 A
// 2. 边界 0：零分仍属于 F
// 3. 非法输入：
//    - null → 未提交
//    - 非数字类型（String/bool/List）→ 类型非法
//    - 负数 / >100 → 范围非法
// 4. 浮点数：支持 double 输入（如 78.5）
//
// 返回值结构：'等级' 或 'ERR:xxx' 形式，便于上层判定。

/// 分级器主函数：接收 Object?，覆盖空安全 + 类型检查 + 范围检查 + 等级映射
String gradeOfExt(Object? input) {
  // 1. 空安全：null 输入
  if (input == null) return 'ERR:未提交(输入为null)';

  // 2. 类型检查：只接受 int / double，其它直接拒绝
  if (input is! num) {
    return 'ERR:类型非法(仅支持num, 实际${input.runtimeType})';
  }

  // 3. 范围检查：[0, 100] 之外非法
  if (input < 0) return 'ERR:范围非法(负数 $input)';
  if (input > 100) return 'ERR:范围非法(超过100: $input)';

  // 4. 边界 100 / 0 仍走正常分级流程
  // 分级使用闭区间，避免边界翻车（90~100 A，80~89 B，... 0~59 F）
  if (input >= 90) return 'A';      // 包含 100
  if (input >= 80) return 'B';
  if (input >= 70) return 'C';
  if (input >= 60) return 'D';
  return 'F';                       // 包含 0
}

/// 把结果转成可读字符串（含原值与等级），便于演示
String describe(Object? input) {
  final g = gradeOfExt(input);
  return 'input=$input(${input.runtimeType}) -> $g';
}

void runGradeOfExt() {
  print('====== 任务3：成绩分级器扩展 ======');

  // 一、边界值（最高频翻车点）
  print('-- 边界 --');
  print(describe(100));   // A，不应越界
  print(describe(0));     // F，不应非法
  print(describe(90));    // A 下边界
  print(describe(89.999));// B（浮点边界，证明 >= 是闭区间）

  // 二、正常值
  print('-- 正常 --');
  print(describe(95));
  print(describe(78.5));
  print(describe(60));
  print(describe(59));

  // 三、非法输入
  print('-- 非法 --');
  print(describe(null));         // 空安全
  print(describe('95'));         // 字符串，类型非法（即使看起来像数字）
  print(describe(true));         // bool，类型非法
  print(describe([90]));         // List，类型非法
  print(describe(-5));           // 负数，范围非法
  print(describe(101));          // 超过100，范围非法
  print(describe(120.5));        // 浮点超界，范围非法

  // 四、批量统计演示：把一组数据用 for-in 跑一遍
  print('-- 批量 --');
  final cases = [100, 0, 95, -1, 101, null, '95', 78.5, 60, true];
  for (var c in cases) {
    print(describe(c));
  }
}
