import 'package:equatable/equatable.dart';

abstract class EducatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchEducators extends EducatorEvent {}
