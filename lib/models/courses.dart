class Course {
  final String title;
  final String educatorName;
  final String description;
  final String durationText;
  final int price;
  final int oldPrice;
  final String imageUrl;
  final Stats stats;
  final List<Video> videos;
  final Timeline timeline;
  final String longDescription;

  Course({
    required this.title,
    required this.educatorName,
    required this.description,
    required this.durationText,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
    required this.stats,
    required this.videos,
    required this.timeline,
    required this.longDescription,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title'],
      educatorName: json['educatorName'],
      description: json['description'],
      durationText: json['durationText'],
      price: json['price'],
      oldPrice: json['oldPrice'],
      imageUrl: json['imageUrl'],
      stats: Stats.fromJson(json['stats']),
      videos: (json['videos'] as List)
          .map((v) => Video.fromJson(v))
          .toList(),
      timeline: Timeline.fromJson(json['timeline']),
      longDescription: json['longDescription'],
    );
  }
}

class Stats {
  final int seatLimit;
  final String perClass;
  final int totalClasses;
  final int enrolled;

  Stats({
    required this.seatLimit,
    required this.perClass,
    required this.totalClasses,
    required this.enrolled,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      seatLimit: json['seatLimit'],
      perClass: json['perClass'],
      totalClasses: json['totalClasses'],
      enrolled: json['enrolled'],
    );
  }
}

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(title: json['title'], url: json['url']);
  }
}

class Timeline {
  final String startDate;
  final String endDate;
  final String duration;

  Timeline({
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      startDate: json['startDate'],
      endDate: json['endDate'],
      duration: json['duration'],
    );
  }
}

class Category {
  final String title;
  final List<Course> courses;

  Category({required this.title, required this.courses});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      courses: (json['courses'] as List)
          .map((c) => Course.fromJson(c))
          .toList(),
    );
  }
}
