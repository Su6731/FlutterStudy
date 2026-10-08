// 仅用于对拍练习运行验证，不参与 main 入口
void q1() {
  String? a;
  String? b = 'world';
  print('Q1 line1: ${a ?? b}, ${a ?? 'fallback'}');
  a = 'hi';
  print('Q1 line2: ${a ?? b}');
}

void q2() {
  String? s;
  print('Q2 line1: ${s?.length}');
  s = 'hello';
  print('Q2 line2: ${s!.length}');
  print('Q2 line3: ${s.length}');
}

void q3() {
  void greet({required String name, int age = 18, String? city}) {
    print('Q3: $name, $age, ${city ?? '未知'}');
  }
  greet(name: 'Tom');
  greet(name: 'Jerry', age: 20);
  greet(name: 'Spike', age: 3, city: '上海');
}

void q4() {
  int a = 17, b = 5;
  print('Q4 line1: ${a / b}');
  print('Q4 line2: ${a ~/ b}');
  print('Q4 line3: ${a % b}');
  print('Q4 line4: ${(a / b).runtimeType}');
}

void q5() {
  int? halfOf(int n) => n.isEven ? n ~/ 2 : null;
  String describe({required int n}) {
    int? half = halfOf(n);
    if (half == null) return 'half=-1, invalid';
    return 'half=$half, double=${half * 2}';
  }
  print('Q5 line1: ${describe(n: 8)}');
  print('Q5 line2: ${describe(n: 7)}');
}

void main() {
  q1();
  print('---');
  q2();
  print('---');
  q3();
  print('---');
  q4();
  print('---');
  q5();
}
