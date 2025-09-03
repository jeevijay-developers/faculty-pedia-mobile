import 'package:equatable/equatable.dart';
import 'package:facultypedia/models/blog_model.dart';

abstract class BlogState extends Equatable {
  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<Blog> blogs;

  BlogLoaded(this.blogs);

  @override
  List<Object> get props => [blogs];
}

class BlogError extends BlogState {
  final String message;

  BlogError(this.message);

  @override
  List<Object> get props => [message];
}
