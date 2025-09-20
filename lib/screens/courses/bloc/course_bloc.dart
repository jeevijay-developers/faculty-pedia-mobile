import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/course_repository.dart';
import '../model/course_model.dart';

abstract class CourseEvent {}

class FetchCourses extends CourseEvent {}

class FetchCourseById extends CourseEvent {
  final String id;
  FetchCourseById(this.id);
}

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CoursesLoaded extends CourseState {
  final List<Course> courses;
  CoursesLoaded(this.courses);
}

class CourseLoaded extends CourseState {
  final Course course;
  CourseLoaded(this.course);
}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository repository;
  CourseBloc(this.repository) : super(CourseInitial()) {
    on<FetchCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await repository.fetchCourses();
        emit(CoursesLoaded(courses));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });

    on<FetchCourseById>((event, emit) async {
      emit(CourseLoading());
      try {
        final course = await repository.fetchCourseById(event.id);
        emit(CourseLoaded(course));
      } catch (e) {
        emit(CourseError(e.toString()));
      }
    });
  }
}
