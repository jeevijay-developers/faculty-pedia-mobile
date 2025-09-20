import 'package:flutter/material.dart';
import '../../utils/snackbar_utils.dart';
import 'package:facultypedia/models/live_test.dart';
import 'package:intl/intl.dart';
import 'live_test_attempt_screen.dart';

class LiveTestResultScreen extends StatelessWidget {
  final String testTitle;
  final int marksObtained;
  final int totalMarks;
  final int totalQuestions;
  final int attempted;
  final int correct;
  final int wrong;
  final int skipped;
  final List<dynamic> questions;
  final Map<String, int?> selectedAnswers;

  const LiveTestResultScreen({
    super.key,
    required this.testTitle,
    required this.marksObtained,
    required this.totalMarks,
    required this.totalQuestions,
    required this.attempted,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double percentage = totalMarks > 0 ? (marksObtained / totalMarks) * 100 : 0;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: primaryColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(height: 40, child: Image.asset("assets/images/fp.png")),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.share, color: primaryColor, size: 16),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getResultColor(percentage).withOpacity(0.1),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getResultColor(percentage),
                            _getResultColor(percentage).withOpacity(0.7),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getResultColor(percentage).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getResultIcon(percentage),
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getResultTitle(percentage),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      testTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$marksObtained',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getResultColor(percentage),
                            ),
                          ),
                          Text(
                            ' / $totalMarks',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getResultColor(
                                percentage,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getResultColor(percentage),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shadowColor: theme.shadowColor.withOpacity(0.1),
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
                              Icon(
                                Icons.analytics,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Test Analysis',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Total Questions',
                                  totalQuestions.toString(),
                                  Icons.quiz,
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Attempted',
                                  attempted.toString(),
                                  Icons.edit,
                                  Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Correct',
                                  correct.toString(),
                                  Icons.check_circle,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Wrong',
                                  wrong.toString(),
                                  Icons.cancel,
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Skipped',
                                  skipped.toString(),
                                  Icons.skip_next,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  theme,
                                  'Accuracy',
                                  attempted > 0
                                      ? '${((correct / attempted) * 100).toStringAsFixed(1)}%'
                                      : '0%',
                                  Icons.track_changes,
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shadowColor: theme.shadowColor.withOpacity(0.1),
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
                              Icon(
                                Icons.list_alt,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Question-wise Analysis',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...questions.asMap().entries.map((entry) {
                            int index = entry.key;
                            var question = entry.value;
                            String questionId = question['id'];

                            int? selectedAnswer = selectedAnswers[questionId];
                            int correctAnswer = question['correctAnswer'];
                            bool isCorrect = selectedAnswer == correctAnswer;
                            bool isAttempted = selectedAnswer != null;

                            return _buildQuestionAnalysis(
                              theme,
                              index + 1,
                              question,
                              selectedAnswer,
                              correctAnswer,
                              isCorrect,
                              isAttempted,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildActionButtons(context, theme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
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
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnalysis(
    ThemeData theme,
    int questionNumber,
    Map<String, dynamic> question,
    int? selectedAnswer,
    int correctAnswer,
    bool isCorrect,
    bool isAttempted,
  ) {
    Color statusColor = !isAttempted
        ? Colors.orange
        : isCorrect
        ? Colors.green
        : Colors.red;

    IconData statusIcon = !isAttempted
        ? Icons.skip_next
        : isCorrect
        ? Icons.check_circle
        : Icons.cancel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    questionNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question['question'],
                  style: theme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(statusIcon, color: statusColor, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Answer:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAttempted
                          ? '${String.fromCharCode(65 + selectedAnswer!)} - ${question['options'][selectedAnswer]}'
                          : 'Not Attempted',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isAttempted ? statusColor : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correct Answer:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${String.fromCharCode(65 + correctAnswer)} - ${question['options'][correctAnswer]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  SnackBarUtils.showInfo(
                    context,
                    'Retry functionality coming soon!',
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Test'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  SnackBarUtils.showSuccess(context, 'Results saved!');
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Results'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getResultColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  IconData _getResultIcon(double percentage) {
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up;
    if (percentage >= 40) return Icons.trending_up;
    return Icons.trending_down;
  }

  String _getResultTitle(double percentage) {
    if (percentage >= 80) return 'Excellent Performance!';
    if (percentage >= 60) return 'Good Job!';
    if (percentage >= 40) return 'Keep Practicing!';
    return 'Need More Practice';
  }
}
