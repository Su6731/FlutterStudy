// 函数示例合集
// 覆盖：命名参数（required / 默认值）、箭头函数（=>）

// 1. 命名参数的 enroll 函数
// - required：调用方必须传
// - 默认值：未传时使用默认
// - 可空：未传且无默认时为 null
void enroll({
  required String name,
  int age = 18, // 默认值
  String? className, // 可选，可空
}) {
  print('[enroll] name=$name, age=$age, class=${className ?? '未分配'}');
}

// 2. 箭头函数 =>：单表达式函数简写
int square(int x) => x * x;

String sayHi(String name) => 'Hi, $name!';

void arrowDemo() {
  print('[arrow] square(5) = ${square(5)}');
  print('[arrow] ${sayHi('Tom')}');
}

// 3. 命名参数调用演示
void funcDemo() {
  enroll(name: 'Alice'); // 仅必填
  enroll(name: 'Bob', age: 20); // + 默认参数覆盖
  enroll(name: 'Cathy', age: 21, className: '高三(2)班'); // 全部
  arrowDemo();
}
