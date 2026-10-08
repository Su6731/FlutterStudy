// 任务4：TraeCode 对拍 · 第2轮
// 题目覆盖：空安全链 + 命名参数、成绩分级边界与类型、Map 取值与类型提升
// 本文件用于实跑验证 AI 参考答案，确保讲解准确。

// Q1：空安全 ?? 与命名参数 + 默认值 + 空串非 null
String format({required String? tag, String fallback = 'N/A'}) => tag ?? fallback;
void q1() {
  print('Q1-1: ${format(tag: null)}');
  print('Q1-2: ${format(tag: 'hi')}');
  print('Q1-3: ${format(tag: '', fallback: '空串')}');   // 空串不是 null！
}

// Q2：成绩分级器（边界 + 类型 + 范围）
String g(Object s) {
  if (s is! num) return 'X';
  if (s < 0 || s > 100) return 'E';
  if (s >= 90) return 'A';
  if (s >= 60) return 'P';
  return 'F';
}
void q2() {
  print('Q2-1: ${g(100)}');
  print('Q2-2: ${g(89.999)}');
  print('Q2-3: ${g(60)}');
  print('Q2-4: ${g('90')}');
  print('Q2-5: ${g(-5)}');
}

// Q3：Map 取值与类型提升
int ageOf(Map<String, dynamic> m) {
  final v = m['age'];
  if (v is int) return v + 1;   // 类型提升：v 在 if 内为 int
  return -1;
}
void q3() {
  print('Q3-1: ${ageOf({'age': 18})}');
  print('Q3-2: ${ageOf({'age': '18'})}');
  print('Q3-3: ${ageOf({})}');
  print('Q3-4: ${ageOf({'age': null})}');
}

void main() {
  print('====== 对拍 第2轮 ======');
  q1();
  print('---');
  q2();
  print('---');
  q3();
}
