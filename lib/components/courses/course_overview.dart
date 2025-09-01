import 'package:facultypedia/components/fullscreen_video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseOverview extends StatelessWidget {
  final String description;
  const CourseOverview({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Top Stats =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _OverviewStat(
                  icon: Icons.people,
                  value: "60",
                  label: "Seat Limit",
                ),
                SizedBox(width: 10),
                _OverviewStat(
                  icon: Icons.timer,
                  value: "2h",
                  label: "Per Class",
                ),
                SizedBox(width: 10),
                _OverviewStat(
                  icon: Icons.school,
                  value: "2",
                  label: "Total Classes",
                ),
                SizedBox(width: 10),
                _OverviewStat(
                  icon: Icons.event_seat,
                  value: "0",
                  label: "Enrolled",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ===== Videos =====
          Row(
            children: [
              Expanded(
                child: _videoCard(
                  context,
                  "Course Introduction",
                  "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _videoCard(
                  context,
                  "Demo Video",
                  "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ===== Description =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description, style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ===== Timeline =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Timeline",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TimelineItem(
                      icon: Icons.calendar_today,
                      color: Colors.blue,
                      label: "Start Date",
                      value: "9/1/2025",
                    ),
                    _TimelineItem(
                      icon: Icons.event,
                      color: Colors.red,
                      label: "End Date",
                      value: "1/20/2026",
                    ),
                    _TimelineItem(
                      icon: Icons.access_time,
                      color: Colors.green,
                      label: "Duration",
                      value: "20 weeks",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Helper Widgets =====
class _OverviewStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _OverviewStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _TimelineItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

Widget _videoCard(BuildContext context, String title, String videoUrl) {
  final videoId = YoutubePlayer.convertUrlToId(videoUrl);

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FullScreenVideoPage(videoUrl: videoUrl),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (videoId != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    "https://img.youtube.com/vi/$videoId/hqdefault.jpg",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    size: 50,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          else
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text("Invalid Video")),
            ),
        ],
      ),
    ),
  );
}
