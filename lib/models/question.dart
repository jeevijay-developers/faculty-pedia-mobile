class Question {
  final String id;
  final String title;
  final String subject;
  final String topic;

  Question({
    required this.id,
    required this.title,
    required this.subject,
    required this.topic,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    try {
      return Question(
        id: json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subject: json['subject']?.toString() ?? '',
        topic: json['topic']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Question: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}
