import 'package:equatable/equatable.dart';

abstract class LiveTestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLiveTests extends LiveTestEvent {}

class FetchLiveTestSeries extends LiveTestEvent {}
