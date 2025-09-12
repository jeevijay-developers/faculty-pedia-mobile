import 'package:facultypedia/screens/educators/repository/educator_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'educator_event.dart';
import 'educator_state.dart';

class EducatorBloc extends Bloc<EducatorEvent, EducatorState> {
  final EducatorRepository repository;

  EducatorBloc({required this.repository}) : super(EducatorInitial()) {
    on<FetchEducators>((event, emit) async {
      emit(EducatorLoading());
      try {
        final educators = await repository.getAllEducators();
        emit(EducatorLoaded(educators));
      } catch (e) {
        emit(EducatorError(e.toString()));
      }
    });
  }
}
