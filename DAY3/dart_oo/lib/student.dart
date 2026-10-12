/// 课程中的学生；所有创建和修改分数的入口执行相同校验。
class Student {
  final String id;
  final String name;
  double _score = 0;

  Student(this.id, this.name, [double score = 0]) {
    this.score = score;
  }

  Student.fromJson(Map<String, dynamic> json)
    : this(
        json['id'] as String,
        json['name'] as String,
        (json['score'] as num).toDouble(),
      );

  double get score => _score;

  set score(double value) {
    if (!value.isFinite || value < 0 || value > 100) {
      throw ArgumentError.value(value, 'score', '分数必须是 0 到 100 的有限数');
    }
    _score = value;
  }

  bool get passed => score >= 60;

  String get grade => switch (score) {
    >= 90 => '优',
    >= 80 => '良',
    >= 60 => '中',
    _ => '不及格',
  };

  @override
  String toString() => '$id $name：$score 分（$grade）';
}
