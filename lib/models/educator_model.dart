class Educator {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String? specialization;
  final String? bio;
  final String? experience;
  final double? rating;
  final int? totalFollowers;
  final EducatorImage? image;
  final List<String>? courses;

  Educator({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    this.specialization,
    this.bio,
    this.experience,
    this.rating,
    this.totalFollowers,
    this.image,
    this.courses,
  });

  factory Educator.fromJson(Map<String, dynamic> json) {
    try {
      // Combine firstName and lastName for name
      String name = '';
      if (json['firstName'] != null && json['lastName'] != null) {
        name = '${json['firstName']} ${json['lastName']}';
      } else {
        name = json['name']?.toString() ?? '';
      }

      return Educator(
        id: json['_id']?.toString() ?? '',
        name: name,
        email: json['email']?.toString() ?? '',
        subject: json['subject']?.toString() ?? '',
        specialization: json['specialization']?.toString(),
        bio: json['bio']?.toString(),
        experience: _parseExperience(json['workExperience']),
        rating: _parseDouble(json['rating']),
        totalFollowers: _parseFollowersCount(json['followers']),
        image: json['image'] != null
            ? EducatorImage.fromJson(json['image'])
            : null,
        courses: _parseCourses(json['courses']),
      );
    } catch (e) {
      print('Error parsing Educator from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static String? _parseExperience(dynamic workExperience) {
    if (workExperience == null) return null;
    try {
      if (workExperience is List && workExperience.isNotEmpty) {
        final experience = workExperience.first;
        if (experience is Map<String, dynamic>) {
          return experience['title']?.toString() ?? 'Professional';
        }
      }
      return 'Professional';
    } catch (e) {
      return 'Professional';
    }
  }

  static int? _parseFollowersCount(dynamic followers) {
    if (followers == null) return 0;
    if (followers is List) return followers.length;
    if (followers is int) return followers;
    return 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static List<String>? _parseCourses(dynamic value) {
    if (value == null) return null;
    try {
      if (value is List) {
        return value
            .map((course) {
              if (course is Map<String, dynamic>) {
                return course['title']?.toString() ?? '';
              } else {
                return course?.toString() ?? '';
              }
            })
            .where((title) => title.isNotEmpty)
            .toList();
      }
      return null;
    } catch (e) {
      print('Error parsing courses: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'bio': bio,
      'experience': experience,
      'rating': rating,
      'totalFollowers': totalFollowers,
      'image': image?.toJson(),
      'courses': courses,
    };
  }
}

class EducatorImage {
  final String? publicId;
  final String? url;

  EducatorImage({this.publicId, this.url});

  factory EducatorImage.fromJson(Map<String, dynamic> json) {
    return EducatorImage(
      publicId: json['public_id']?.toString(),
      url: json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url};
  }
}
