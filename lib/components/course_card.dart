import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String educatorName;
  final String description;
  final String durationText;
  final double price;
  final double oldPrice;
  final VoidCallback onEnroll;
  final VoidCallback onViewDetails;

  const CourseCard({
    super.key,
    required this.title,
    required this.educatorName,
    required this.description,
    required this.durationText,
    required this.price,
    required this.oldPrice,
    required this.onEnroll,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, color: Colors.white, size: 40),
                  SizedBox(height: 4),
                  Text("Course",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ),

          // Text details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(educatorName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(durationText,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blue)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("₹${price.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text("₹${oldPrice.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: onEnroll,
                        child: const Text("Enroll Now"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: onViewDetails,
                        child: const Text("View Details"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
