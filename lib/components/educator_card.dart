import 'package:flutter/material.dart';

class EducatorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subject;
  final String education;
  final String experience;
  final String specialization;
  final VoidCallback onViewProfile;

  const EducatorCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.subject,
    required this.education,
    required this.experience,
    required this.specialization,
    required this.onViewProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subject,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                _infoRow("Education", education),
                _infoRow("Experience", experience),
                _infoRow("Specialization", specialization),
                const SizedBox(height: 8),
                InkWell(
                  onTap: onViewProfile,
                  child: const Text(
                    "View Profile →",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
