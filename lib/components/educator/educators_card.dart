import 'package:flutter/material.dart';

class EducatorsCard extends StatelessWidget {
  final String name;
  final String subject;
  final String description;
  final String education;
  final String experience;
  final double rating;
  final int reviews;
  final int followers;
  final String tag;
  final String imageUrl;
  final VoidCallback onProfileTap;

  const EducatorsCard({
    super.key,
    required this.name,
    required this.subject,
    required this.description,
    required this.education,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.followers,
    required this.tag,
    required this.imageUrl,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with Image + Name + Subject + Followers
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imageUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Name + Subject + Followers
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.book, color: Colors.blue, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            subject,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      Text(
                        "Followers: $followers",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              description,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // Education & Experience
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Education: $education",
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  "Experience: $experience",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(
                  " $rating ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "($reviews reviews)",
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tag (e.g., NEET)
            Chip(label: Text(tag), backgroundColor: Colors.grey.shade200),
            const SizedBox(height: 10),

            // View Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onProfileTap,
                child: const Text(
                  "View Full Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
