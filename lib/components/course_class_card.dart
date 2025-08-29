import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class CourseClassCard extends StatelessWidget {
  final String title;
  final String topic;
  final DateTime date;
  final String timeRange;
  final String description;
  final String subject;
  final int durationMinutes;
  final VoidCallback onJoinClass;
  final VoidCallback onDownloadPPT;
  final VoidCallback onDownloadPDF;

  const CourseClassCard({
    super.key,
    required this.title,
    required this.topic,
    required this.date,
    required this.timeRange,
    required this.description,
    required this.subject,
    required this.durationMinutes,
    required this.onJoinClass,
    required this.onDownloadPPT,
    required this.onDownloadPDF,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (Title, Date, Time)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy').format(date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    timeRange,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 20),

          // Description
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          // Subject & Duration Row
          Row(
            children: [
              const Icon(Icons.menu_book, size: 16, color: Color(0xFF155DFC)),
              const SizedBox(width: 4),
              Text("Subject: $subject", style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text("Duration: $durationMinutes mins",
                  style: const TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 12),

          // Join Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onJoinClass,
              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
              label: const Text(
                "Join Class",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const Divider(height: 20),

          // Course Materials
          const Text(
            "Course Materials:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onDownloadPPT,
                icon: const Icon(Icons.download, size: 16),
                label: const Text("PPT"),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: onDownloadPDF,
                icon: const Icon(Icons.download, size: 16),
                label: const Text("PDF"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
