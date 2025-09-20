import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'live_test_result_screen.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class LiveTestAttemptScreen extends StatefulWidget {
  final String testTitle;
  final int duration; // in minutes

  const LiveTestAttemptScreen({
    super.key,
    required this.testTitle,
    this.duration = 60,
  });

  @override
  State<LiveTestAttemptScreen> createState() => _LiveTestAttemptScreenState();
}

class _LiveTestAttemptScreenState extends State<LiveTestAttemptScreen> {
  Map<String, dynamic> testData = {};
  List<dynamic> questions = [];
  Map<String, int?> selectedAnswers = {};
  int currentQuestionIndex = 0;
  late Timer _timer;
  int remainingSeconds = 0;
  bool isLoading = true;
  final PageController _pageController = PageController();
  final ScrollController _questionScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration * 60;
    _loadTestData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _questionScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTestData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/live_test_questions.json',
      );
      final data = json.decode(response);
      setState(() {
        testData = data;
        questions = data['questions'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading test data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _submitTest();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _selectAnswer(String questionId, int answerIndex) {
    setState(() {
      selectedAnswers[questionId] = answerIndex;
    });
  }

  void _scrollToCurrentQuestion() {
    if (_questionScrollController.hasClients && questions.isNotEmpty) {
      // Calculate the position to scroll to center the current question
      double itemWidth = 48.0; // 40 width + 8 right margin
      double screenWidth = MediaQuery.of(context).size.width;
      double targetPosition =
          (currentQuestionIndex * itemWidth) -
          (screenWidth / 2) +
          (itemWidth / 2);

      // Ensure we don't scroll beyond the bounds
      double maxScrollExtent =
          _questionScrollController.position.maxScrollExtent;
      targetPosition = targetPosition.clamp(0.0, maxScrollExtent);

      _questionScrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _scrollToCurrentQuestion();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _scrollToCurrentQuestion();
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToCurrentQuestion();
  }

  void _submitTest() {
    _timer.cancel();

    // Calculate results
    int totalQuestions = questions.length;
    int attempted = selectedAnswers.length;
    int correct = 0;
    int wrong = 0;

    for (var entry in selectedAnswers.entries) {
      String questionId = entry.key;
      int? selectedAnswer = entry.value;

      var question = questions.firstWhere((q) => q['id'] == questionId);
      int correctAnswer = question['correctAnswer'];

      if (selectedAnswer == correctAnswer) {
        correct++;
      } else {
        wrong++;
      }
    }

    int skipped = totalQuestions - attempted;
    int marksObtained =
        (correct * (testData['positiveMarks'] as int? ?? 4)) +
        (wrong * (testData['negativeMarks'] as int? ?? -1));
    int totalMarks = totalQuestions * (testData['positiveMarks'] as int? ?? 4);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTestResultScreen(
          testTitle: widget.testTitle,
          marksObtained: marksObtained,
          totalMarks: totalMarks,
          totalQuestions: totalQuestions,
          attempted: attempted,
          correct: correct,
          wrong: wrong,
          skipped: skipped,
          questions: questions,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    if (isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 2,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.error,
              size: 16,
            ),
          ),
          onPressed: () => _showExitDialog(),
        ),
        title: Column(
          children: [
            Text(
              widget.testTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: remainingSeconds < 300
                  ? theme.colorScheme.error.withOpacity(0.1)
                  : primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: remainingSeconds < 300
                      ? theme.colorScheme.error
                      : primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTime(remainingSeconds),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: remainingSeconds < 300
                        ? theme.colorScheme.error
                        : primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: theme.dividerColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),

          // Question Navigation Strip
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              controller: _questionScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                String questionId = questions[index]['id'];
                bool isAnswered = selectedAnswers.containsKey(questionId);
                bool isCurrent = index == currentQuestionIndex;

                return GestureDetector(
                  onTap: () => _goToQuestion(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? primary
                          : isAnswered
                          ? theme.colorScheme.secondary
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCurrent ? primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isCurrent || isAnswered
                              ? theme.colorScheme.onPrimary
                              : theme.textTheme.bodyMedium?.color?.withOpacity(
                                  0.9,
                                ),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Question Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentQuestionIndex = index;
                });
              },
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];
                String questionId = question['id'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Card
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
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.quiz_rounded,
                                      color: primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Question ${index + 1}',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                    ),
                                  ),
                                  if (selectedAnswers.containsKey(questionId))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Answered',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontSize: 12,
                                              color:
                                                  theme.colorScheme.secondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                question['question'],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options
                      ...List.generate(question['options'].length, (
                        optionIndex,
                      ) {
                        bool isSelected =
                            selectedAnswers[questionId] == optionIndex;

                        return GestureDetector(
                          onTap: () => _selectAnswer(questionId, optionIndex),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primary.withOpacity(0.1)
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? primary
                                    : theme.dividerColor.withOpacity(0.4),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? primary
                                          : theme.dividerColor.withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: theme.colorScheme.onPrimary,
                                          size: 16,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  String.fromCharCode(65 + optionIndex),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? primary
                                        : theme.textTheme.bodyMedium?.color
                                              ?.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question['options'][optionIndex],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      color: isSelected
                                          ? primary
                                          : theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: currentQuestionIndex == questions.length - 1 ? 2 : 1,
                  child: ElevatedButton.icon(
                    onPressed: currentQuestionIndex == questions.length - 1
                        ? () => _showSubmitDialog()
                        : _nextQuestion,
                    icon: Icon(
                      currentQuestionIndex == questions.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      currentQuestionIndex == questions.length - 1
                          ? 'Submit Test'
                          : 'Next',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentQuestionIndex == questions.length - 1
                          ? theme.colorScheme.secondary
                          : primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Test'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Exit',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    int attempted = selectedAnswers.length;
    int remaining = questions.length - attempted;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to submit?'),
            const SizedBox(height: 12),
            Text('Questions Attempted: $attempted'),
            Text('Questions Remaining: $remaining'),
            if (remaining > 0)
              Text(
                'Unanswered questions will be marked as incorrect.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTest();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              'Submit',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
