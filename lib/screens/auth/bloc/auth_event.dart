import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupRequested extends AuthEvent {
  final String email;
  final String mobileNumber;
  final String name;
  final String password;

  SignupRequested(this.email, this.mobileNumber, this.name, this.password);

  @override
  List<Object?> get props => [email, mobileNumber, name, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends AuthEvent {
  final String token;
  final String userId;
  final String name;
  final String email;
  final String mobile;

  UpdateProfileRequested(this.token, this.userId, this.name, this.email, this.mobile);

  @override
  List<Object?> get props => [token, userId, name, email, mobile];
}

