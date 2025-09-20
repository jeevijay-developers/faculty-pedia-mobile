import 'package:facultypedia/models/live_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/live_test_bloc.dart';
import 'bloc/live_test_event.dart';
import 'bloc/live_test_state.dart';
import 'live_test_detail_screen.dart';
import 'repository/live_test_repository.dart';

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
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(height: 40, child: Image.asset("assets/images/fp.png")),
        centerTitle: true,
      ),
      body: _loading || _bloc == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
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
                            theme.cardColor,
                            theme.colorScheme.primary.withOpacity(0.05),
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
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Live Tests',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Take live tests and track your progress in real-time',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
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
                                theme.colorScheme.primary,
                              ),
                            ),
                          );
                        } else if (state is LiveTestLoaded) {
                          if (state.tests.isEmpty) {
                            // DARK THEME FIX: Use theme-aware text colors instead of dividerColor
                            final subduedColor = theme
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6);
                            return Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.quiz_outlined,
                                    size: 80,
                                    color: subduedColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Live Tests Available',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: subduedColor,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check back later for new live tests',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: subduedColor,
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
                          // DARK THEME FIX: Use the theme's error color for all elements
                          final errorColor = theme.colorScheme.error;
                          return Padding(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 80,
                                  color: errorColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Oops! Something went wrong',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: errorColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: errorColor.withOpacity(0.8),
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
                                    backgroundColor: theme.colorScheme.error,
                                    foregroundColor: theme.colorScheme.onError,
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

  Widget _buildTestCard(BuildContext context, LiveTest test) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 8,
        shadowColor: theme.shadowColor.withOpacity(0.1),
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
                colors: [
                  theme.cardColor,
                  theme.colorScheme.primary.withOpacity(0.05),
                ],
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
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.schedule,
                          color: theme.colorScheme.onPrimary,
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(test.subject),
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          Icons.schedule,
                          'Start Time',
                          DateFormat(
                            'MMM dd, hh:mm a',
                          ).format(test.startDate.toLocal()),
                          theme.colorScheme.primary,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: theme.dividerColor.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          Icons.timer,
                          'Duration',
                          'Live Test',
                          theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      /* onTap is handled by InkWell */
                    },
                    child: const Text(
                      'Join Live Test',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
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
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color valueColor,
  ) {
    final theme = Theme.of(context);
    // DARK THEME FIX: Use a readable, theme-aware color for the label
    final labelColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.7);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: labelColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
