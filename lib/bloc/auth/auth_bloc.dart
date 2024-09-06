import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<FetchVersionEvent>(_onFetchVersionEvent);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Fetching token and validity from API
      final tokenInfo = await authRepository.login(event.email, event.password);
      log(tokenInfo.toString());
      final token = tokenInfo['token'];
      final tokenValidity = tokenInfo['validity'];

      // Store token and validity time using SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('token_expiry',
          DateTime.now().millisecondsSinceEpoch + tokenValidity as int);

      // Set a timer for auto-logout based on token validity
      Future.delayed(Duration(milliseconds: tokenValidity), () {
        add(LogoutEvent());
      });
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // Remove token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('token_expiry');
    log('logout');
    emit(AuthUnauthenticated('Session expired, please log in again.'));
  }

  Future<void> _onFetchVersionEvent(FetchVersionEvent event, Emitter<AuthState> emit) async {
    final version = await authRepository.getVersion();
    log('version loadeddddddd');
    emit(AuthVersionLoaded(version));
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? tokenExpiry = prefs.getInt('token_expiry');

    if (token != null && tokenExpiry != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime < tokenExpiry) {
        return true;
      } else {
        await prefs.remove('token');
        await prefs.remove('token_expiry');
      }
    }
    return false;
  }
}
