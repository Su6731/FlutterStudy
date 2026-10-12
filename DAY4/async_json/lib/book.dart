class Book {
  final String id;
  final String title;
  final String category;
  final int borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.borrowCount,
  });

  factory Book.fromJson(
    Map<String, dynamic> json, {
    void Function(String)? onWarning,
  }) {
    String requiredText(String key) {
      final value = json[key];
      if (value == null) throw FormatException('字段缺失：$key 是必填字段');
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('字段类型错误：$key 必须是非空字符串');
      }
      return value;
    }

    final id = requiredText('id');
    final title = requiredText('title');
    final category = requiredText('category');
    final value = json['borrowCount'];
    int count = 0;
    if (value == null) {
      onWarning?.call('字段缺失：图书 $id 的 borrowCount 缺失或为空，已使用默认值 0');
    } else if (value is! num ||
        !value.isFinite ||
        value < 0 ||
        value != value.truncateToDouble()) {
      throw FormatException('字段类型错误：图书 $id 的 borrowCount 必须是非负整数');
    } else {
      count = value.toInt();
    }
    return Book(id: id, title: title, category: category, borrowCount: count);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'borrowCount': borrowCount,
  };
}
