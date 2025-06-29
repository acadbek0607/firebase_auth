part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  /// Optional convenience getter, null by default
  UserEntity? get user => null;

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity authenticatedUser;

  const Authenticated(this.authenticatedUser);

  @override
  UserEntity get user => authenticatedUser;

  @override
  List<Object?> get props => [authenticatedUser];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
