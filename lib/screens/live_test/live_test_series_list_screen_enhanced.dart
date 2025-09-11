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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Live Test Series',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: _loading || _bloc == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ),
            )
          : BlocProvider.value(
              value: _bloc!,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<LiveTestBloc, LiveTestState>(
                  builder: (context, state) {
                    if (state is LiveTestLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1565C0),
                          ),
                        ),
                      );
                    } else if (state is LiveTestLoaded) {
                      if (state.testSeries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Test Series Available',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Check back later for new test series',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          _bloc!.add(FetchLiveTestSeries());
                        },
                        child: ListView.separated(
                          itemCount: state.testSeries.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final series = state.testSeries[index];
                            return _buildTestSeriesCard(context, series);
                          },
                        ),
                      );
                    } else if (state is LiveTestError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                _bloc!.add(FetchLiveTestSeries());
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
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
              ),
            ),
    );
  }

  Widget _buildTestSeriesCard(BuildContext context, LiveTestSeries series) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LiveTestSeriesDetailScreen(series: series),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.blue.shade50],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      color: Color(0xFF1565C0),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          series.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Practice Series',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                series.descriptionShort,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.people_outline,
                    label: 'Enrolled',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    icon: Icons.assignment_outlined,
                    label: 'Tests Available',
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    'Starts: ${DateFormat('MMM dd, yyyy').format(series.startDate.toLocal())}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
