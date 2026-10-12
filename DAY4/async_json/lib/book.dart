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

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    borrowCount: (json['borrowCount'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'borrowCount': borrowCount,
  };
}
