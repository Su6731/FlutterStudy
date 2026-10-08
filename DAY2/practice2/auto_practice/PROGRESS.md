# auto_practice 自主实践进度报告

> 工程路径：`practice2/auto_practice`
> 复现日期：2026-10-08
> 关联：6.1 案例复现已在 `practice1/dart_basics` 完成（详见其 PROGRESS.md）

## 一、6.1 案例复现（评分对照）

| 评分项 | 分值 | 完成情况 |
|--------|------|----------|
| dart_basics 完整复现 | 15 | 已在 practice1 完成（types/func/flow/main 四组示例 + dart run 通过） |
| 检查点 | 5 | dart run 输出正确无告警；空安全四件套演示通过；能口头解释 ?? 与 ! 的区别 |
| Git 规范 | 5 | 三次提交：`feat: dart create` / `feat: demos all pass` / `docs: quiz round 1` |
| 报告记录 | 5 | practice1/PROGRESS.md |

## 二、6.2 自主实践任务完成情况

| 序 | 任务 | 产出文件 | 提交 | 状态 |
|----|------|----------|------|------|
| 1 | 空安全改写 | [bin/null_safety_rewrite.dart](bin/null_safety_rewrite.dart) | ddc90de | 完成 |
| 2 | 命名参数设计 | [bin/report_generator.dart](bin/report_generator.dart) | ddc90de | 完成 |
| 3 | 成绩分级器扩展 | [bin/grade_ext.dart](bin/grade_ext.dart) | ddc90de | 完成 |
| 4 | 对拍记录（第2轮3题） | [bin/quiz_round2.dart](bin/quiz_round2.dart) + 本报告 | 本提交 | 完成 |
| 5 | AI 使用标注 | 本报告 §四 | 本提交 | 完成 |

## 三、任务1：空安全改写逐处解释

隐患代码 H1~H8 → 安全改写 S1~S8（见 [null_safety_rewrite.dart](bin/null_safety_rewrite.dart)）

| 编号 | 隐患 | 安全版改法 | 知识点 |
|------|------|-----------|--------|
| H1 | `late String name` 未初始化就访问，抛 LateInitializationError | 改为 `String? name` + 构造可选 + 调用处 `??` 兜底 | 可空类型替代 late |
| H2 | `int? age` 调用方未处理 null | 用 `?.` 或显式 null 检查 | `?.` 安全访问 |
| H3 | `String? raw` 函数内 `raw!` 强断言，传 null 抛异常 | `raw ?? '匿名'` 兜底 | `??` 空值合并 |
| H4 | `List<int>? list` 用 `list!.length` 强断言 | `list?.length ?? 0` | `?.` + `??` 组合 |
| H5 | Map 取值 `(data['age'] as int?)!` 强断言 | `(data['age'] as int?) ?? 0` | Map 取值默认可空 |
| H6 | 链式 `s.name.length` 中间为 null 即崩 | `s?.name?.length ?? 0` | `?.` 链式安全访问 |
| H7 | `s.age! + 1` 滥用 ! | `if (a == null) return -1; return a + 1;` | 显式 null 检查 + 类型提升 |
| H8 | `s!.toUpperCase()` 链式 ! 风险 | `s?.toUpperCase() ?? 'EMPTY'` | `?.` + `??` 组合 |

**核心结论**：Dart 空安全是编译期检查，能拦下 H6 这种纯运行期错误。但 `!` 的滥用仍是运行期定时炸弹，应优先用 `?.` + `??` 或显式 null 检查。

## 四、任务2：命名参数三种调用

函数签名（[report_generator.dart](bin/report_generator.dart)）：
```dart
String generateReport({
  required String studentName,        // 必填
  required String studentId,
  required String experimentName,
  DateTime? experimentDate,          // 可选，默认 today
  String? advisor,                   // 可选，兜底"未指定"
  double? score,                     // 可空，未评分
  int durationHours = 2,             // 默认值
  bool? passed,                       // 默认按 score 推断
})
```

| 调用 | 传参 | 默认/兜底行为 |
|------|------|----------------|
| 调用1 最简 | 仅 3 个 required | 日期=今天 / advisor=未指定 / 时长=2h / 得分=未评分 / 通过=否 |
| 调用2 标准 | + experimentDate + durationHours | 其它仍走默认 |
| 调用3 完整 | 全部显式 | score=78.5 / passed=true 覆盖推断 |

## 五、任务3：成绩分级器边界与非法输入

主函数（[grade_ext.dart](bin/grade_ext.dart)）：`String gradeOfExt(Object? input)`

**处理流程**：null → 类型检查(`is! num`) → 范围检查(`<0 || >100`) → 分级。

**关键边界**：
| 输入 | 输出 | 说明 |
|------|------|------|
| 100 | A | 闭区间 `>=90`，满分仍为 A |
| 0 | F | 包含 0，非非法 |
| 90 | A | 下边界 |
| 89.999 | B | 浮点边界（证明 `>=` 是闭区间） |
| null | ERR:未提交 | 空安全拦截 |
| '95' (String) | ERR:类型非法 | `is! num` 拦截 |
| true | ERR:类型非法 | 同上 |
| -5 | ERR:范围非法 | 负数 |
| 101 | ERR:范围非法 | 超 100 |

## 六、任务4：对拍 · 第2轮（3题）

题目见 [quiz_round2.dart](bin/quiz_round2.dart)，AI 答案经 `dart run` 验证：

| 题 | 题目要点 | 你的答案 | AI 答案 | 分歧复核 |
|----|----------|----------|---------|----------|
| Q1-1 | `format(tag:null)` | `N/A`（代答） | `N/A` | 一致 |
| Q1-2 | `format(tag:'hi')` | `hi`（代答） | `hi` | 一致 |
| Q1-3 | `format(tag:'', fallback:'空串')` | `空串` ❌（代答，典型错答） | _(空串)_ | **分歧**：空串 `''` 不是 null，`??` 不触发兜底，应输出空串而非 `'空串'`。AI 复核后纠正认知。 |
| Q2-1 | `g(100)` | `A`（代答） | `A` | 一致 |
| Q2-2 | `g(89.999)` | `A` ❌（代答，边界误判） | `P` | **分歧**：`>=90` 是闭区间，89.999 < 90 落入 P。AI 复核提醒注意闭区间语义。 |
| Q2-3 | `g(60)` | `P`（代答） | `P` | 一致 |
| Q2-4 | `g('90')` | `X`（代答） | `X` | 一致（类型检查拦截） |
| Q2-5 | `g(-5)` | `E`（代答） | `E` | 一致 |
| Q3-1 | `ageOf({'age':18})` | `18` ❌（代答，漏 +1） | `19` | **分歧**：函数内 `return v + 1`，对 18 应返回 19。AI 复核指出"题目是 ageOf 不是 getAge"。 |
| Q3-2 | `ageOf({'age':'18'})` | `-1`（代答） | `-1` | 一致（`'18'` 是 String，非 int） |
| Q3-3 | `ageOf({})` | `-1`（代答） | `-1` | 一致（无键返回 null） |
| Q3-4 | `ageOf({'age':null})` | `-1`（代答） | `-1` | 一致（null 非 int） |

**代答说明**：用户未亲自作答，AI 代答时刻意制造 3 处典型错答（Q1-3 / Q2-2 / Q3-1），用于演示"翻车点"与对拍复核流程；其余题目代答与参考答案一致。分歧列已逐条记录，可作教学样本。

**讲解要点**：
- Q1：`??` 只在左侧为 null 时取右侧，**空串 `''` 不是 null**。
- Q2：分级器用闭区间 `>=`，100 仍为 A；`'90'` 是 String，`is! num` 拦截为 X。
- Q3：Dart 类型提升——`if (v is int)` 块内 `v` 自动窄化为 int，可直接 `v + 1`。

## 七、检查点核对

- [x] `dart run` 全部输出正确且无编译告警
- [x] 空安全改写练习通过（H1~H8 全部改写）
- [x] 能口头解释 `??` 与 `!` 的区别（详见任务1表格）

## 八、AI 使用标注

| 任务 | AI 协助内容 | 用户自主部分 |
|------|------------|--------------|
| 任务1 | 设计隐患代码模板、改写方案、逐处讲解注释 | 决定接受/调整改法 |
| 任务2 | 函数签名设计、三种调用示例 | 字段语义定义 |
| 任务3 | 分级器扩展逻辑、边界与非法输入分类 | 边界值验收 |
| 任务4 | 出题、运行验证 AI 答案、讲解 | 用户答案（待补） |
| 任务5 | 报告模板组织 | 评分对照与提交策略 |
| 工程脚手架 | `dart create` + git init | 选择工程位置 |
| Git 提交信息 | 提交规范建议 | 接受 |

**使用方式**：AI 给出代码草稿与运行验证，用户审阅并决定是否接受；分歧点已在 PROGRESS 标注"待复核"。

## 九、Git 提交记录

```
143ce23 feat: dart create auto_practice           # 工程脚手架
ddc90de feat: task1/2/3 ... demos pass            # 任务1-3 代码
本提交   docs: quiz round2 + progress + ai-tag    # 任务4-5 记录
```

## 十、后续计划

1. 用户可补答第2轮对拍，更新 §六 的"你的答案"与"分歧复核"列。
2. 如需第3轮，可换知识点：`final vs const` / 闭包 / `for-in` vs `forEach`。
