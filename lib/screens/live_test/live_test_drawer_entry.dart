import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:facultypedia/screens/live_test/live_test_series_list_screen.dart';

class LiveTestDrawerEntry extends StatelessWidget {
  const LiveTestDrawerEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.stopwatch, color: Color(0xFF4A90E2)),
      title: const Text('Live Tests'),
      subtitle: const Text('Attempt Live Tests'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LiveTestSeriesListScreen()),
        );
      },
    );
  }
}
