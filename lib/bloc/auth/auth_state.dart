part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {
}

class AuthLoading extends AuthState {}

class AuthVersionLoaded extends AuthState {
  final String version;

  AuthVersionLoaded(this.version);
}


class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {
  final String message;

  AuthUnauthenticated(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
