import 'package:flutter/material.dart';
import 'package:facultypedia/models/live_test_series.dart';

class LiveTestSeriesDetailScreen extends StatelessWidget {
  final LiveTestSeries series;
  const LiveTestSeriesDetailScreen({Key? key, required this.series})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(series.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (series.imageUrl.isNotEmpty)
              Image.network(series.imageUrl, height: 180, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              series.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Price: ₹${series.price}'),
            const SizedBox(height: 8),
            Text('No. of Tests: ${series.noOfTests}'),
            const SizedBox(height: 8),
            Text('Start: ${series.startDate.toLocal()}'),
            Text('End: ${series.endDate.toLocal()}'),
            const SizedBox(height: 16),
            Text(
              series.descriptionShort,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(series.descriptionLong),
            // TODO: Add list of tests, enrolled students, etc.
          ],
        ),
      ),
    );
  }
}
