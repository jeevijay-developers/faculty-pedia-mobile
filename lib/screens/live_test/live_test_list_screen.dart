import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/live_test_bloc.dart';
import 'bloc/live_test_event.dart';
import 'bloc/live_test_state.dart';
import 'repository/live_test_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'live_test_detail_screen.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class LiveTestListScreen extends StatefulWidget {
  const LiveTestListScreen({super.key});

  @override
  State<LiveTestListScreen> createState() => _LiveTestListScreenState();
}

class _LiveTestListScreenState extends State<LiveTestListScreen> {
  LiveTestBloc? _bloc;
  bool _loading = true;

  Future<void> _initBloc() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? '';
    _bloc = LiveTestBloc(repository: LiveTestRepository(token: token));
    _bloc!.add(FetchLiveTests());
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

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
      ),
      body: _loading || _bloc == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            )
          : BlocProvider.value(
              value: _bloc!,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            kPrimaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.quiz_rounded,
                              size: 60,
                              color: kPrimaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Live Tests',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Take live tests and track your progress in real-time',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<LiveTestBloc, LiveTestState>(
                      builder: (context, state) {
                        if (state is LiveTestLoading) {
                          return Padding(
                            padding: const EdgeInsets.all(50),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kPrimaryColor,
                              ),
                            ),
                          );
                        } else if (state is LiveTestLoaded) {
                          if (state.tests.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.quiz_outlined,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Live Tests Available',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check back later for new live tests',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.tests.length,
                              itemBuilder: (context, index) {
                                final test = state.tests[index];
                                return _buildTestCard(context, test);
                              },
                            ),
                          );
                        } else if (state is LiveTestError) {
                          return Padding(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 80,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Oops! Something went wrong',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _bloc!.add(FetchLiveTests());
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try Again'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTestCard(BuildContext context, test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LiveTestDetailScreen(test: test),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, kPrimaryColor.withOpacity(0.05)],
              ),
            ),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
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
                          Icons.schedule,
                          color: Colors.white,
                          size: 30,
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                test.subject,
                                style: TextStyle(
                                  fontSize: 12,
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
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              Icons.schedule,
                              'Start Time',
                              DateFormat(
                                'MMM dd, hh:mm a',
                              ).format(test.startDate.toLocal()),
                              kPrimaryColor,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          Expanded(
                            child: _buildStatItem(
                              Icons.timer,
                              'Duration',
                              'Live Test',
                              kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kPrimaryColor,
                                kPrimaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Join Live Test',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
