class LiveTestSeries {
  final String id;
  final String title;
  final String descriptionShort;
  final String descriptionLong;
  final double price;
  final int noOfTests;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String educatorId;
  final List<String> enrolledStudents;
  final List<String> liveTests;
  final bool isCourseSpecific;
  final String? courseId;

  LiveTestSeries({
    required this.id,
    required this.title,
    required this.descriptionShort,
    required this.descriptionLong,
    required this.price,
    required this.noOfTests,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.educatorId,
    required this.enrolledStudents,
    required this.liveTests,
    required this.isCourseSpecific,
    this.courseId,
  });

  factory LiveTestSeries.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing LiveTestSeries from: $json');

      // Handle enrolledStudents array - it contains objects with studentId
      List<String> enrolledList = [];
      if (json['enrolledStudents'] != null) {
        try {
          final studentsData = json['enrolledStudents'] as List<dynamic>;
          enrolledList = studentsData
              .map(
                (e) => (e is Map<String, dynamic>)
                    ? e['studentId']?.toString() ?? ''
                    : e.toString(),
              )
              .where((id) => id.isNotEmpty)
              .toList();
        } catch (e) {
          print('Error parsing enrolledStudents: $e');
          enrolledList = [];
        }
      }

      // Handle liveTests array - it contains objects with _id, title, etc.
      List<String> testsList = [];
      if (json['liveTests'] != null) {
        try {
          final testsData = json['liveTests'] as List<dynamic>;
          testsList = testsData
              .map(
                (e) => (e is Map<String, dynamic>)
                    ? e['_id']?.toString() ?? ''
                    : e.toString(),
              )
              .where((id) => id.isNotEmpty)
              .toList();
        } catch (e) {
          print('Error parsing liveTests: $e');
          testsList = [];
        }
      }

      // Handle educatorId - it might be an object or string
      String educatorIdValue = '';
      if (json['educatorId'] != null) {
        if (json['educatorId'] is Map<String, dynamic>) {
          educatorIdValue = json['educatorId']['_id']?.toString() ?? '';
        } else {
          educatorIdValue = json['educatorId'].toString();
        }
      }

      return LiveTestSeries(
        id: json['_id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        descriptionShort:
            json['description']?['short']?.toString() ?? 'No description',
        descriptionLong:
            json['description']?['long']?.toString() ?? 'No description',
        price: (json['price'] ?? 0).toDouble(),
        noOfTests: int.tryParse(json['noOfTests']?.toString() ?? '0') ?? 0,
        startDate:
            DateTime.tryParse(json['startDate']?.toString() ?? '') ??
            DateTime.now(),
        endDate:
            DateTime.tryParse(json['endDate']?.toString() ?? '') ??
            DateTime.now(),
        imageUrl: json['image']?['url']?.toString() ?? '',
        educatorId: educatorIdValue,
        enrolledStudents: enrolledList,
        liveTests: testsList,
        isCourseSpecific: json['isCourseSpecific'] ?? false,
        courseId: json['courseId']?.toString(),
      );
    } catch (e) {
      print('Error parsing LiveTestSeries: $e');
      print('Failed JSON: $json');
      rethrow;
    }
  }
}
