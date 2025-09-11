import 'question.dart';

class LiveTest {
  final String id;
  final String title;
  final String subject;
  final String descriptionShort;
  final String descriptionLong;
  final String imageUrl;
  final DateTime startDate;
  final int duration;
  final int? positiveMarks;
  final int? negativeMarks;
  final String markingType;
  final List<Question> questions;
  final String? testSeriesId;
  final String educatorId;

  LiveTest({
    required this.id,
    required this.title,
    required this.subject,
    required this.descriptionShort,
    required this.descriptionLong,
    required this.imageUrl,
    required this.startDate,
    required this.duration,
    this.positiveMarks,
    this.negativeMarks,
    required this.markingType,
    required this.questions,
    this.testSeriesId,
    required this.educatorId,
  });

  factory LiveTest.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing LiveTest from: $json');
      
      // Handle questions array safely
      List<Question> questionsList = [];
      if (json['questions'] != null) {
        try {
          final questionsData = json['questions'] as List<dynamic>;
          questionsList = questionsData
              .map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print('Error parsing questions: $e');
          questionsList = [];
        }
      }
      
      return LiveTest(
        id: json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subject: json['subject']?.toString() ?? '',
        descriptionShort: json['description']?['short']?.toString() ?? 'No description',
        descriptionLong: json['description']?['long']?.toString() ?? 'No description',
        imageUrl: json['image']?['url']?.toString() ?? '', // This field might be missing
        startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
        duration: int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
        positiveMarks: json['overallMarks']?['positive'] != null 
            ? int.tryParse(json['overallMarks']['positive'].toString()) 
            : null,
        negativeMarks: json['overallMarks']?['negative'] != null 
            ? int.tryParse(json['overallMarks']['negative'].toString()) 
            : null,
        markingType: json['markingType']?.toString() ?? 'standard',
        questions: questionsList,
        testSeriesId: json['testSeriesId']?.toString(),
        educatorId: json['educatorId']?.toString() ?? '', // This field might be missing
      );
    } catch (e) {
      print('Error parsing LiveTest: $e');
      print('Failed JSON: $json');
      rethrow;
    }
  }
}
