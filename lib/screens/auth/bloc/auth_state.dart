import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Map<String, dynamic> data;

  AuthSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> userData;

  AuthAuthenticated(this.userData);

  @override
  List<Object?> get props => [userData];
}
