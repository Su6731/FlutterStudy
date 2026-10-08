// 任务1：空安全改写
// 说明：作业页未附具体隐患代码，故自行设计一段典型隐患代码，
//       覆盖：late 未初始化、滥用 !、可空未处理、Map 取值后强断言、链式调用未保护。

// ============================================================
// 【隐患版 unsafe】—— 以下代码仅作反面教材展示
// 注意：Dart 空安全是编译期检查，下面这段代码若取消注释直接编译会报错，
//       这正说明空安全机制在编译期就拦下了大多数运行期崩溃；
//       我们以"伪代码"形式保留它，便于对照"隐患→安全"的改写过程。
// ============================================================
/*
class StudentUnsafe {
  // H1: late 字段未在构造里赋值，访问前若未赋值会抛 LateInitializationError
  late String name;
  int? age;            // H2: 可空类型，调用方未处理 null
  String? className;
}

// H3: 函数形参是可空，却用 ! 强断言，调用方传 null 时直接抛异常
String? forceName(String? raw) => raw!;

// H4: 形参可空 List，直接 ! 强断言后访问 .length 与索引
void printListUnsafe(List<int>? list) {
  print('len=${list!.length}');
  print('first=${list[0]}');
}

// H5: Map 取值返回可空，却用 ! 强断言键一定存在
int readAgeUnsafe(Map<String, dynamic> data) => (data['age'] as int?)!;

// H6: 链式调用未使用 ?.，中间任一为 null 就崩（此处编译期就报错）
int? nameLengthUnsafe(StudentUnsafe? s) => s.name.length;

// H7: 可空 int 直接参与算术运算，需要 ! 强断言才能编译
int? nextAgeUnsafe(StudentUnsafe s) => s.age! + 1;

// H8: 函数返回可空，调用方又用 ! 强断言，链式崩溃风险叠加
String upperUnsafe(String? s) => s!.toUpperCase();
*/

// ============================================================
// 【安全版 safe】—— 逐处对应改写，使用空安全四件套 ? / ?? / ?. / !
// （! 仅在能保证非空的场景才使用，并尽量改成显式 null 检查）
// ============================================================
class StudentSafe {
  // 改写 H1: 用可空 String? 替代 late，访问处用 ?? 兜底
  String? name;
  int? age;
  String? className;

  StudentSafe({this.name, this.age, this.className});
}

// 改写 H3: 用 ?? 兜底，不再滥用 !
String safeName(String? raw) => raw ?? '匿名';

// 改写 H4: 用 ?. 安全访问，长度返回可空并兜底
void printListSafe(List<int>? list) {
  print('len=${list?.length ?? 0}');        // null 时返回 0
  print('first=${list?.isNotEmpty == true ? list!.first : null}');
  // 这里 list! 安全：已通过 isNotEmpty==true 证明非空
}

// 改写 H5: Map 取值后用 ?? 0 兜底，避免键不存在崩溃
int readAgeSafe(Map<String, dynamic> data) => (data['age'] as int?) ?? 0;

// 改写 H6: 用 ?. 链式安全访问，返回可空后用 ?? 兜底
int nameLengthSafe(StudentSafe? s) => s?.name?.length ?? 0;

// 改写 H7: 显式 null 检查后类型提升为非空，不再滥用 !
int nextAgeSafe(StudentSafe s) {
  final a = s.age;
  if (a == null) return -1;       // 显式分支
  return a + 1;                   // 这里 a 已被类型提升为 int
}

// 改写 H8: 用 ?. 链式访问 + ?? 兜底，避免 ! 链式崩溃
String upperSafe(String? s) => s?.toUpperCase() ?? 'EMPTY';

// ============================================================
// 演示入口
// ============================================================
void runNullSafetyRewrite() {
  print('====== 任务1：空安全改写演示 ======');

  // 安全版：所有边界都能优雅处理
  print('safeName(null) = ${safeName(null)}');
  print('safeName("Tom") = ${safeName('Tom')}');

  printListSafe(null);
  printListSafe([10, 20]);

  print('readAgeSafe({}) = ${readAgeSafe({})}');
  print('readAgeSafe({"age": 18}) = ${readAgeSafe({'age': 18})}');

  print('nameLengthSafe(null) = ${nameLengthSafe(null)}');
  print('nameLengthSafe(StudentSafe(name:"Bob")) = ${nameLengthSafe(StudentSafe(name: 'Bob'))}');

  print('nextAgeSafe(StudentSafe(age: null)) = ${nextAgeSafe(StudentSafe())}');
  print('nextAgeSafe(StudentSafe(age: 17)) = ${nextAgeSafe(StudentSafe(age: 17))}');

  print('upperSafe(null) = ${upperSafe(null)}');
  print('upperSafe("hi") = ${upperSafe('hi')}');
}
