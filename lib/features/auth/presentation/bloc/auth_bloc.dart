import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/usecases/usecases.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<SignInResquested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onSignInRequested(
    SignInResquested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Loading());
    try {
      final user = await signInWithEmail(event.email, event.password);
      currentUserNotifier.value = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(Loading());
    try {
      final user = await signUpWithEmail(event.email, event.password);
      currentUserNotifier.value = user;
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await signOut(); // FIX: call the function!
    currentUserNotifier.value = null;
    emit(Unauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getCurrentUser();
    if (user != null) {
      currentUserNotifier.value = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }
}
