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

        // Store login timestamp for 7-day expiry
        final loginTimestamp = DateTime.now().millisecondsSinceEpoch;

        await prefs.setString("token", token?.toString() ?? "");
        await prefs.setString(
          "userId",
          (user['_id'] ?? data['userId'] ?? "").toString(),
        );
        await prefs.setString(
          "name",
          (user['name'] ?? data['name'] ?? "").toString(),
        );
        await prefs.setString(
          "email",
          (user['email'] ?? data['email'] ?? "").toString(),
        );
        await prefs.setString(
          "mobile",
          (user['mobileNumber'] ?? data['mobileNumber'] ?? "").toString(),
        );
        await prefs.setInt("loginTimestamp", loginTimestamp);

        log("data ---> $data");
        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs
          .clear(); // This already clears everything including loginTimestamp
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
        if (fields.containsKey("name"))
          await prefs.setString("name", fields["name"]!);
        if (fields.containsKey("email"))
          await prefs.setString("email", fields["email"]!);
        if (fields.containsKey("mobileNumber"))
          await prefs.setString("mobile", fields["mobileNumber"]!);

        emit(AuthSuccess(data));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<CheckAuthStatusRequested>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");
        final loginTimestamp = prefs.getInt("loginTimestamp");

        if (token == null || token.isEmpty || loginTimestamp == null) {
          emit(AuthInitial());
          return;
        }

        // Check if 7 days have passed (7 * 24 * 60 * 60 * 1000 milliseconds)
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        final sevenDaysInMillis = 7 * 24 * 60 * 60 * 1000;

        if (currentTime - loginTimestamp > sevenDaysInMillis) {
          // Session expired, clear data
          await prefs.clear();
          emit(AuthInitial());
          return;
        }

        // Session is still valid, restore user data
        final userData = {
          'token': token,
          'userId': prefs.getString("userId") ?? "",
          'name': prefs.getString("name") ?? "",
          'email': prefs.getString("email") ?? "",
          'mobile': prefs.getString("mobile") ?? "",
        };

        emit(AuthAuthenticated(userData));
      } catch (e) {
        emit(AuthInitial());
      }
    });

    on<RefreshSessionRequested>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        if (token != null && token.isNotEmpty) {
          // Refresh the login timestamp to extend session
          final newTimestamp = DateTime.now().millisecondsSinceEpoch;
          await prefs.setInt("loginTimestamp", newTimestamp);
        }
      } catch (e) {
        // If there's an error, don't change the current state
        log("Error refreshing session: $e");
      }
    });
  }
}
