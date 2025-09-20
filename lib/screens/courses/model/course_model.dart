class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    imageUrl: json['imageUrl'] ?? '',
  );
}
