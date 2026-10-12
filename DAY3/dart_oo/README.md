# DAY3 课程成绩册

完成指南第五部分、6.1 和 6.2 必做内容，不做 6.3 选做。

## 运行

在本目录执行：

```powershell
dart pub get
dart run
dart test
dart analyze
dart run example/mixin_refactor.dart
```

## 文件说明

| 文件 | 内容 |
| --- | --- |
| lib/student.dart | 私有分数、命名构造、getter、校验 setter |
| lib/gradebook.dart | 内部 List、四项统计、及格排名、Logger 混入 |
| lib/logger.dart | 日志 mixin |
| bin/dart_oo.dart | 五名学生的统计演示 |
| example/mixin_refactor.dart | 继承日志基类与混入 Logger 的可运行对照 |
| test/gradebook_test.dart | 六个测试，覆盖正常及异常路径 |
| ../实践记录.md | 设计说明、要求对照、AI 标注与验证记录 |
| ../verification/ | 工具实际运行输出 |

## 统计约定

优为 90–100，良为 80–不足 90，中为 60–不足 80，不足 60 为不及格。指南未指定阈值，这里采用以上约定。空册平均分为 0、最高分学生为 null、及格人数为 0。

average 使用 fold，maxBy 使用 reduce，countPassed 使用 where，groupByGrade 使用 fold，均不含手写 for 循环。

passedRanking 组合 where → toList → sort → map → toList → asMap → map，超过五个集合方法。sort 在新列表上执行，不改变原列表顺序。

构造和 setter 均拒绝负数、超过 100、NaN 和无穷大；JSON 分数接受 int 或 double。成绩册复制输入列表，但学生对象仍共享，修改分数后统计随之更新。

## mixin 改造理由

改造前 `GradeBookBefore extends LoggingBase` 仅为日志复用继承父类。改造后实际成绩册 `GradeBook with Logger` 移除日志继承层。成绩册不是一种日志器，mixin 更适合表达可复用能力，也保留了继承业务基类的位置。可运行对照见 example/mixin_refactor.dart。

检查点解释：`with A, B` 同名且签名兼容的方法由后混入的 B 提供；交换顺序会改变最终实现。本项目不开展 6.3 线性化实验。

## AI 使用标注

本次代码、测试与说明由 OpenAI Codex 根据指南辅助生成，并由 Codex 执行运行、静态检查和测试。测试数据为演示数据。提交者应阅读代码，并能解释封装、空值处理、集合链与 mixin 设计。
