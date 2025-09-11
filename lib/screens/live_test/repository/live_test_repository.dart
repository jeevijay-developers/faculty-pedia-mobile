import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:facultypedia/models/live_test.dart';
import 'package:facultypedia/models/live_test_series.dart';
import 'package:facultypedia/utils/constants.dart';

class LiveTestRepository {
  final String token;
  LiveTestRepository({required this.token});

  Future<List<LiveTest>> getAllLiveTests({int page = 1, int limit = 10}) async {
    final url = Uri.parse('$MAIN_URL/live-test?page=$page&limit=$limit');
    print('Fetching live tests from: $url');
    print('Using token: $token');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        print('Parsed JSON: $jsonResponse');
        final data = jsonResponse['tests'] as List;
        print('Tests data: $data');

        List<LiveTest> liveTests = [];
        for (int i = 0; i < data.length; i++) {
          try {
            final test = LiveTest.fromJson(data[i]);
            liveTests.add(test);
          } catch (e) {
            print('Error parsing test at index $i: $e');
            print('Failed test data: ${data[i]}');
            // Continue with other tests instead of failing completely
          }
        }

        return liveTests;
      } catch (e) {
        print('Error parsing live tests JSON: $e');
        throw Exception('Failed to parse live tests: $e');
      }
    } else {
      throw Exception(
        'Failed to load live tests: ${response.statusCode} ${response.body}',
      );
    }
  }

  Future<List<LiveTestSeries>> getAllLiveTestSeries({
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse('$MAIN_URL/test-series?page=$page&limit=$limit');
    print('Fetching test series from: $url');
    print('Using token: $token');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        print('Parsed test series JSON: $jsonResponse');
        final data = jsonResponse['testSeries'] as List;
        print('Test series data: $data');

        List<LiveTestSeries> testSeriesList = [];
        for (int i = 0; i < data.length; i++) {
          try {
            final series = LiveTestSeries.fromJson(data[i]);
            testSeriesList.add(series);
          } catch (e) {
            print('Error parsing test series at index $i: $e');
            print('Failed test series data: ${data[i]}');
            // Continue with other series instead of failing completely
          }
        }

        return testSeriesList;
      } catch (e) {
        print('Error parsing test series JSON: $e');
        throw Exception('Failed to parse test series: $e');
      }
    } else {
      throw Exception(
        'Failed to load test series: ${response.statusCode} ${response.body}',
      );
    }
  }
}
