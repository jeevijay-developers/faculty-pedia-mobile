class Blog {
  final String id;
  final String title;
  final String slug;
  final String author;
  final String shortContent;
  final String longContent;
  final String imageUrl;
  final List<String> tags;
  final String category;
  final bool isPublished;

  Blog({
    required this.id,
    required this.title,
    required this.slug,
    required this.author,
    required this.shortContent,
    required this.longContent,
    required this.imageUrl,
    required this.tags,
    required this.category,
    required this.isPublished,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      author: json['author'] ?? '',
      shortContent: json['content']?['short'] ?? '',
      longContent: json['content']?['long'] ?? '',
      imageUrl: json['image']?['url'] ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      category: json['category'] ?? '',
      isPublished: json['isPublished'] ?? false,
    );
  }
}
