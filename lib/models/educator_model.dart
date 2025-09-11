class Educator {
  final String id;
  final String name;
  final String email;
  final String specialization;
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
    required this.specialization,
    this.bio,
    this.experience,
    this.rating,
    this.totalFollowers,
    this.image,
    this.courses,
  });

  factory Educator.fromJson(Map<String, dynamic> json) {
    return Educator(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      bio: json['bio']?.toString(),
      experience: json['experience']?.toString(),
      rating: json['rating']?.toDouble(),
      totalFollowers: json['totalFollowers']?.toInt(),
      image: json['image'] != null ? EducatorImage.fromJson(json['image']) : null,
      courses: json['courses'] != null 
          ? List<String>.from(json['courses'].map((course) => course['title']?.toString() ?? ''))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
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

  EducatorImage({
    this.publicId,
    this.url,
  });

  factory EducatorImage.fromJson(Map<String, dynamic> json) {
    return EducatorImage(
      publicId: json['public_id']?.toString(),
      url: json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }
}
