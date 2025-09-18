import 'package:facultypedia/components/fullscreen_video.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseOverview extends StatelessWidget {
  final String description;
  const CourseOverview({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Overview Stats =====
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5, // Adjusted for better layout
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: const [
              _ModernOverviewStat(
                icon: Icons.people_rounded,
                value: "60",
                label: "Seat Limit",
                color: Colors.blue,
              ),
              _ModernOverviewStat(
                icon: Icons.timer_rounded,
                value: "2h",
                label: "Per Class",
                color: Colors.green,
              ),
              _ModernOverviewStat(
                icon: Icons.school_rounded,
                value: "2",
                label: "Total Classes",
                color: Colors.orange,
              ),
              _ModernOverviewStat(
                icon: Icons.event_seat_rounded,
                value: "0",
                label: "Enrolled",
                color: Colors.purple,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ===== Videos Section =====
        SectionTitle(
          icon: Icons.play_circle_filled_rounded,
          color: Colors.red,
          title: "Preview Videos",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _modernVideoCard(
                context,
                "Course Introduction",
                "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _modernVideoCard(
                context,
                "Demo Video",
                "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE",
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // ===== Description =====
        SectionTitle(
          icon: Icons.description_rounded,
          color: theme.colorScheme.primary,
          title: "Course Description",
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ),
        const SizedBox(height: 24),

        // ===== Timeline =====
        const SectionTitle(
          icon: Icons.schedule_rounded,
          color: Colors.indigo,
          title: "Course Timeline",
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Expanded(
                child: _ModernTimelineItem(
                  icon: Icons.calendar_today_rounded,
                  color: Colors.blue,
                  label: "Start Date",
                  value: "Sep 1, 2025",
                ),
              ),
              Expanded(
                child: _ModernTimelineItem(
                  icon: Icons.event_rounded,
                  color: Colors.red,
                  label: "End Date",
                  value: "Jan 20, 2026",
                ),
              ),
              Expanded(
                child: _ModernTimelineItem(
                  icon: Icons.access_time_rounded,
                  color: Colors.green,
                  label: "Duration",
                  value: "20 weeks",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===== Section Title Widget =====
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ===== Modern Helper Widgets =====
class _ModernOverviewStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ModernOverviewStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernTimelineItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _ModernTimelineItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

Widget _modernVideoCard(BuildContext context, String title, String videoUrl) {
  final theme = Theme.of(context);
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (videoId != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    "https://img.youtube.com/vi/$videoId/hqdefault.jpg",
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: theme.dividerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Invalid Video",
                  style: TextStyle(color: theme.hintColor),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
