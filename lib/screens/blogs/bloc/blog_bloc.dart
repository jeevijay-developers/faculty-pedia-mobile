import 'package:facultypedia/screens/blogs/repository/blog_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository repository;

  BlogBloc({required this.repository}) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      emit(BlogLoading());
      try {
        final blogs = await repository.getAllBlogs();
        emit(BlogLoaded(blogs));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    });
  }
}
