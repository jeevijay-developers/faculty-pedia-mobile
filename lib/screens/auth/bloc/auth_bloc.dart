import 'dart:developer';
import 'package:facultypedia/screens/auth/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await repository.signup(
          email: event.email,
          mobileNumber: event.mobileNumber,
          name: event.name,
          password: event.password,
        );
        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await repository.login(
          email: event.email,
          password: event.password,
        );

        final prefs = await SharedPreferences.getInstance();

        // Your API example shows TOKEN in caps and nested user object.
        final user = (data['user'] ?? {}) as Map<String, dynamic>;
        final token = data['TOKEN'] ?? data['token'];

        await prefs.setString("token", token?.toString() ?? "");
        await prefs.setString("userId", (user['_id'] ?? data['userId'] ?? "").toString());
        await prefs.setString("name", (user['name'] ?? data['name'] ?? "").toString());
        await prefs.setString("email", (user['email'] ?? data['email'] ?? "").toString());
        await prefs.setString("mobile", (user['mobileNumber'] ?? data['mobileNumber'] ?? "").toString());

        log("data ---> $data");
        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthInitial());
    });

    on<UpdateProfileRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final currentName = prefs.getString("name") ?? "";
        final currentEmail = prefs.getString("email") ?? "";
        final currentMobile = prefs.getString("mobile") ?? "";

        // Build PATCH-like body with only changed fields
        final fields = <String, String>{};
        if (event.name.trim() != currentName.trim()) {
          fields["name"] = event.name.trim();
        }
        if (event.email.trim() != currentEmail.trim()) {
          fields["email"] = event.email.trim();
        }
        if (event.mobile.trim() != currentMobile.trim()) {
          fields["mobileNumber"] = event.mobile.trim();
        }

        if (fields.isEmpty) {
          emit(AuthFailure("No changes to update."));
          return;
        }

        final repo = ProfileRepository();
        final data = await repo.updateProfilePartial(
          token: event.token,
          userId: event.userId,
          fields: fields,
        );

        // Update local values only for changed keys
        if (fields.containsKey("name")) await prefs.setString("name", fields["name"]!);
        if (fields.containsKey("email")) await prefs.setString("email", fields["email"]!);
        if (fields.containsKey("mobileNumber")) await prefs.setString("mobile", fields["mobileNumber"]!);

        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
