import 'package:equatable/equatable.dart';

abstract class BlogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchBlogs extends BlogEvent {}
