// 保存指南给出的修复前转换方式，用于复现缺失字段错误，不是生产入口。
void main() {
  final json = <String, dynamic>{'id': 'B001', 'title': '测试', 'category': '编程'};
  try {
    final count = (json['borrowCount'] as num).toInt();
    print(count);
  } on TypeError catch (error) {
    print('修复前实际错误：$error');
  }
}
