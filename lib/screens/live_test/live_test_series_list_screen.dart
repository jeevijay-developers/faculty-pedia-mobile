import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/live_test_bloc.dart';
import 'bloc/live_test_event.dart';
import 'bloc/live_test_state.dart';
import 'repository/live_test_repository.dart';
import 'package:facultypedia/models/live_test_series.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'live_test_series_detail_screen.dart';

class LiveTestSeriesListScreen extends StatefulWidget {
  const LiveTestSeriesListScreen({super.key});

  @override
  State<LiveTestSeriesListScreen> createState() =>
      _LiveTestSeriesListScreenState();
}

class _LiveTestSeriesListScreenState extends State<LiveTestSeriesListScreen> {
  LiveTestBloc? _bloc;
  bool _loading = true;

  Future<void> _initBloc() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final repository = LiveTestRepository(token: token);
      _bloc = LiveTestBloc(repository: repository);
      _bloc!.add(FetchLiveTestSeries());
    }
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
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
                              Icons.quiz,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Live Test Series',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Practice with real-time tests and improve your performance',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
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
                                theme.colorScheme.primary,
                              ),
                            ),
                          );
                        } else if (state is LiveTestLoaded) {
                          if (state.testSeries.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.quiz_outlined,
                                    size: 80,
                                    color: theme.hintColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Test Series Available',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check back later for new test series',
                                    style: theme.textTheme.bodyLarge,
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
                              itemCount: state.testSeries.length,
                              itemBuilder: (context, index) {
                                final series = state.testSeries[index];
                                return _buildTestSeriesCard(
                                  context,
                                  series,
                                  theme,
                                );
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
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Oops! Something went wrong',
                                  style: theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _bloc!.add(FetchLiveTestSeries());
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try Again'),
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

  Widget _buildTestSeriesCard(
    BuildContext context,
    LiveTestSeries series,
    ThemeData theme,
  ) {
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
                builder: (_) => LiveTestSeriesDetailScreen(series: series),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.cardColor,
            ),
            child: Column(
              children: [
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
                          Icons.quiz,
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
                              series.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Test Series',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        series.descriptionShort,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              theme,
                              Icons.schedule,
                              'Start Date',
                              DateFormat(
                                'MMM dd',
                              ).format(series.startDate.toLocal()),
                              theme.colorScheme.primary,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: theme.dividerColor,
                          ),
                          Expanded(
                            child: _buildStatItem(
                              theme,
                              Icons.assessment,
                              'Tests',
                              'Available',
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LiveTestSeriesDetailScreen(
                                    series: series,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Start Test Series'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Icon(
                          Icons.bookmark_outline,
                          color: theme.hintColor,
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
    ThemeData theme,
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
