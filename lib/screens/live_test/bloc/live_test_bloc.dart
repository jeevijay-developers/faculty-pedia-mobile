import 'package:flutter_bloc/flutter_bloc.dart';
import 'live_test_event.dart';
import 'live_test_state.dart';
import '../repository/live_test_repository.dart';

class LiveTestBloc extends Bloc<LiveTestEvent, LiveTestState> {
  final LiveTestRepository repository;
  LiveTestBloc({required this.repository}) : super(LiveTestInitial()) {
    on<FetchLiveTests>(_onFetchLiveTests);
    on<FetchLiveTestSeries>(_onFetchLiveTestSeries);
  }

  Future<void> _onFetchLiveTests(
    FetchLiveTests event,
    Emitter<LiveTestState> emit,
  ) async {
    emit(LiveTestLoading());
    try {
      final tests = await repository.getAllLiveTests();
      final testSeries = await repository.getAllLiveTestSeries();
      emit(LiveTestLoaded(tests: tests, testSeries: testSeries));
    } catch (e) {
      emit(LiveTestError(e.toString()));
    }
  }

  Future<void> _onFetchLiveTestSeries(
    FetchLiveTestSeries event,
    Emitter<LiveTestState> emit,
  ) async {
    emit(LiveTestLoading());
    try {
      final testSeries = await repository.getAllLiveTestSeries();
      emit(LiveTestLoaded(tests: [], testSeries: testSeries));
    } catch (e) {
      emit(LiveTestError(e.toString()));
    }
  }
}
