part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInResquested extends AuthEvent {
  final String email;
  final String password;

  const SignInResquested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested(this.email, this.password);
}

class SignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
