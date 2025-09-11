import 'package:equatable/equatable.dart';
import 'package:facultypedia/models/live_test.dart';
import 'package:facultypedia/models/live_test_series.dart';

abstract class LiveTestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LiveTestInitial extends LiveTestState {}

class LiveTestLoading extends LiveTestState {}

class LiveTestLoaded extends LiveTestState {
  final List<LiveTest> tests;
  final List<LiveTestSeries> testSeries;
  LiveTestLoaded({required this.tests, required this.testSeries});
  @override
  List<Object?> get props => [tests, testSeries];
}

class LiveTestError extends LiveTestState {
  final String message;
  LiveTestError(this.message);
  @override
  List<Object?> get props => [message];
}
