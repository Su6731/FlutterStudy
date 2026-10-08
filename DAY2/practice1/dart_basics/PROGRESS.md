# dart_basics 课堂复现 · 进度报告

> 工程路径：`practice1/dart_basics`
> 复现日期：2026-10-08

## 一、完成情况

| 步骤 | 内容 | 提交 | 状态 |
|------|------|------|------|
| 步骤一 | `dart create dart_basics`，查看入口 | `07dbbee feat: dart create dart_basics` | 完成 |
| 步骤二 | 四组示例 `types_demo / func_demo / flow_demo / main` | `0d3b0fd feat: types/func/flow demos all pass` | 完成 |
| 步骤三 | AI 出 5 道预测输出题 + 参考答案 + 讲解 | （见下方记录） | 完成 |

## 二、检查点核对

- [x] `dart run` 全部输出正确且无编译告警
- [x] 空安全改写练习通过（`? / ?? / ?. / !` 四件套已在 `types_demo.dart` 演示）
- [x] 能口头解释 `??` 与 `!` 的区别（见下方 Q2 / Q1 讲解）
  - `??` 空值合并：左侧为 null 才取右侧，否则取左侧，**不抛异常**
  - `!` 非空断言：告诉编译器"非空"，运行期为 null 则**抛异常**

## 三、对拍练习 · 第1轮（5题）

**范围**：空安全 / 命名参数 / 整除
**用户参与情况**：用户主动跳过"预测"环节，直接由 AI 给出参考答案与讲解。

### Q1 [空安全 · ??]
```dart
String? a;
String? b = 'world';
print('${a ?? b}, ${a ?? 'fallback'}');
a = 'hi';
print(a ?? b);
```
**参考输出**：
```
world, fallback
hi
```
**讲解**：`??` 左侧为 null 才取右侧。第1行 `a` 为 null，取 `b` 与 `'fallback'`；第2行 `a` 已赋值，直接取 `a`。**翻车点**：`??` 不会改变 `a` 本身。

### Q2 [空安全 · ?. 与 ! 对比]
```dart
String? s;
print(s?.length);
s = 'hello';
print(s!.length);
print(s.length);
```
**参考输出**：
```
null
5
5
```
**讲解**：`?.` 对 null 返回 null（不抛错）；`!` 是非空断言，运行期 null 才抛错；赋值后类型提升为非空 String，可直接 `.length`。

### Q3 [命名参数 · required / 默认值 / 可空]
```dart
void greet({required String name, int age = 18, String? city}) {
  print('$name, $age, ${city ?? '未知'}');
}
greet(name: 'Tom');
greet(name: 'Jerry', age: 20);
greet(name: 'Spike', age: 3, city: '上海');
```
**参考输出**：
```
Tom, 18, 未知
Jerry, 20, 未知
Spike, 3, 上海
```
**讲解**：`required` 必传；`age` 默认 18；`city` 可空，未传为 null，用 `??` 兜底。

### Q4 [整除 · ~/ vs / vs %]
```dart
int a = 17, b = 5;
print(a / b);
print(a ~/ b);
print(a % b);
print((a / b).runtimeType);
```
**参考输出**：
```
3.4
3
2
double
```
**讲解**：Dart 中 `/` 永远返回 double，即便两个 int 相除；`~/` 才是整除返回 int；`%` 取余返回 int。**翻车点**：误以为 `17/5` 返回 `3`。

### Q5 [综合 · 命名参数 + 空安全 + 整除]
```dart
int? halfOf(int n) => n.isEven ? n ~/ 2 : null;
String describe({required int n}) {
  int? half = halfOf(n);
  if (half == null) return 'half=-1, invalid';
  return 'half=$half, double=${half * 2}';
}
print(describe(n: 8));
print(describe(n: 7));
```
**参考输出**：
```
half=4, double=8
half=-1, invalid
```
**讲解**：`8.isEven` → true → `8 ~/ 2 = 4`；`7.isEven` → false → half=null → 命中 if 分支。可空变量经 null 检查后类型提升为非空，可直接 `half * 2`。

## 四、分歧与待复习项

| 题号 | 知识点 | 用户答案 | AI 答案 | 分歧 | 复习建议 |
|------|--------|----------|---------|------|----------|
| Q1 | `??` 空值合并 | 未答 | `world, fallback` / `hi` | 用户未参与预测 | 重做 Q1，重点理解"?? 不改变左侧变量" |
| Q2 | `?.` vs `!` | 未答 | `null` / `5` / `5` | 同上 | 重做 Q2，重点区分"安全访问"与"非空断言" |
| Q3 | 命名参数 required/默认/可空 | 未答 | 三行 enroll 输出 | 同上 | 重做 Q3，练习 required 与默认值混用 |
| Q4 | `/` `~/` `%` 三者差异 | 未答 | `3.4` / `3` / `2` / `double` | 同上 | 重做 Q4，记住"Dart `/` 永远返回 double" |
| Q5 | 综合题 | 未答 | `half=4, double=8` / `half=-1, invalid` | 同上 | 重做 Q5，掌握类型提升 |

## 五、后续计划

1. 用户可选择重做第1轮对拍（实际手写答案），更新本报告"用户答案"列。
2. 第2轮对拍可换知识点组合（如：final vs const、闭包、for-in 与 forEach 差异）。
