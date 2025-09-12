import 'package:equatable/equatable.dart';
import 'package:facultypedia/models/educator_model.dart';

abstract class EducatorState extends Equatable {
  @override
  List<Object> get props => [];
}

class EducatorInitial extends EducatorState {}

class EducatorLoading extends EducatorState {}

class EducatorLoaded extends EducatorState {
  final List<Educator> educators;

  EducatorLoaded(this.educators);

  @override
  List<Object> get props => [educators];
}

class EducatorError extends EducatorState {
  final String message;

  EducatorError(this.message);

  @override
  List<Object> get props => [message];
}
