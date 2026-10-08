// 类型与空安全示例合集
// 覆盖：变量声明、字符串插值、空安全四件套（? / ?? / ?. / !）

// 1. 变量声明：var / final / const / 显式类型
void variableDemo() {
  var name = 'Dart'; // 类型推断为 String
  final year = 2026; // 运行期常量，只赋值一次
  const pi = 3.14159; // 编译期常量
  int score = 95;
  double rate = 4.7;
  print('[variable] name=$name, year=$year, pi=$pi, score=$score, rate=$rate');
}

// 2. 字符串插值：$var 与 ${表达式}
void interpolationDemo() {
  String lang = 'Dart';
  int version = 3;
  print('I am learning $lang, version ${version + 10}'); // ${} 可放表达式
  // 多行字符串与原始字符串
  var multi = '''
    line1: hello
    line2: $lang
  ''';
  print(multi.trim());
}

// 3. 空安全四件套：? / ?? / ?. / !
void nullSafetyDemo() {
  // 3.1 ? 可空类型声明
  String? nickname; // 默认 null
  print('[nullable] nickname = $nickname');

  // 3.2 ?? 空值合并：左侧为 null 时取右侧
  String display = nickname ?? '匿名用户';
  print('[?? default] display = $display');

  // 3.3 ?. 条件成员访问：左侧为 null 时返回 null，而非抛错
  int? length = nickname?.length;
  print('[?. access] length = $length');

  // 3.4 ! 非空断言：告诉编译器“我确定它非空”，运行期为 null 则抛错
  String definitely = 'sure!';
  print('[! assert] length = ${definitely.length}');

  // 翻车对比：直接用 .length 会编译报错，因为 nickname 可能为 null
  // print(nickname.length); // 编译期错误
}
