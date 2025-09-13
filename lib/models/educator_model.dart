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
  final String? mobileNumber;

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
    this.mobileNumber,
  });

  factory Educator.fromJson(Map<String, dynamic> json) {
    try {
      // Handle firstName/lastName from backend and combine them
      String firstName = json['firstName']?.toString().trim() ?? '';
      String lastName = json['lastName']?.toString().trim() ?? '';
      String name = '';

      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        name =
            '${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1)} ${lastName.substring(0, 1).toUpperCase()}${lastName.substring(1)}';
      } else if (firstName.isNotEmpty) {
        name =
            '${firstName.substring(0, 1).toUpperCase()}${firstName.substring(1)}';
      } else if (lastName.isNotEmpty) {
        name =
            '${lastName.substring(0, 1).toUpperCase()}${lastName.substring(1)}';
      } else {
        name = 'Unknown Educator';
      }

      return Educator(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: name,
        email: json['email']?.toString() ?? '',
        subject:
            json['subject']?.toString() ?? json['subjects']?.toString() ?? '',
        specialization: json['specialization']?.toString(),
        bio: json['bio']?.toString() ?? json['description']?.toString(),
        experience: _parseExperience(json['workExperience']),
        rating: _parseDouble(json['rating']),
        totalFollowers: _parseFollowersCount(json['followers']),
        image: json['image'] != null
            ? EducatorImage.fromJson(json['image'])
            : null,
        courses: _parseCourses(json['courses']),
        mobileNumber: json['mobileNumber']?.toString(),
      );
    } catch (e) {
      throw Exception('Failed to parse Educator from JSON: $e');
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
      'mobileNumber': mobileNumber,
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
