import 'package:flutter/material.dart';
import 'package:facultypedia/models/live_test.dart';
import 'package:intl/intl.dart';
import 'live_test_attempt_screen.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class LiveTestDetailScreen extends StatelessWidget {
  final LiveTest test;
  const LiveTestDetailScreen({Key? key, required this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: kPrimaryColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          child: Image.asset("assets/images/fp.png"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.share, color: kPrimaryColor, size: 16),
            ),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor.withOpacity(0.1), Colors.white],
                ),
              ),
              child: test.imageUrl.isNotEmpty
                  ? Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              test.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildPlaceholderImage(),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.quiz_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              test.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                test.subject,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description, color: kPrimaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            test.descriptionShort,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            test.descriptionLong,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Test Details Grid
                  _buildTestDetailsGrid(),

                  const SizedBox(height: 20),

                  // Marking Scheme Card
                  _buildMarkingSchemeCard(),

                  const SizedBox(height: 30),

                  // Action Buttons
                  _buildActionButtons(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.1),
            kPrimaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 60,
              color: kPrimaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Live Test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestDetailsGrid() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: kPrimaryColor),
                const SizedBox(width: 8),
                Text(
                  'Test Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.schedule,
                    'Start Time',
                    DateFormat(
                      'MMM dd, yyyy\nhh:mm a',
                    ).format(test.startDate.toLocal()),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey[300]),
                Expanded(
                  child: _buildDetailItem(
                    Icons.timer,
                    'Duration',
                    '${test.duration} minutes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            _buildDetailItem(
              Icons.assessment,
              'Marking Type',
              test.markingType,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkingSchemeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grade, color: kPrimaryColor),
                const SizedBox(width: 8),
                Text(
                  'Marking Scheme',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMarkingItem(
                    Icons.add_circle,
                    'Positive Marks',
                    '${test.positiveMarks ?? '-'}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMarkingItem(
                    Icons.remove_circle,
                    'Negative Marks',
                    '${test.negativeMarks ?? '-'}',
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveTestAttemptScreen(
                    testTitle: test.title,
                    duration: test.duration,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Start Live Test',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement bookmark functionality
                },
                icon: Icon(Icons.bookmark_outline, color: kPrimaryColor),
                label: Text('Bookmark', style: TextStyle(color: kPrimaryColor)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement reminder functionality
                },
                icon: Icon(Icons.notifications_outlined, color: kPrimaryColor),
                label: Text(
                  'Set Reminder',
                  style: TextStyle(color: kPrimaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: kPrimaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMarkingItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
