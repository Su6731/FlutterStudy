import 'types_demo.dart';
import 'func_demo.dart';
import 'flow_demo.dart';

// main 统一调用所有 demo 并输出
void main(List<String> arguments) {
  print('====== 1. 变量声明 ======');
  variableDemo();

  print('\n====== 2. 字符串插值 ======');
  interpolationDemo();

  print('\n====== 3. 空安全四件套 ======');
  nullSafetyDemo();

  print('\n====== 4. 函数：命名参数 + 箭头 ======');
  funcDemo();

  print('\n====== 5. 流程控制：gradeOf + for-in ======');
  flowDemo();
}
