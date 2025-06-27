import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/usecases/usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

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
    on<SignInResquested>((event, emit) async {
      emit(Loading());
      try {
        final user = await signInWithEmail(event.email, event.password);
        currentUserNotifier.value =
            user; // where 'user' is the signed-in UserEntity

        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        final user = await signUpWithEmail(event.email, event.password);
        currentUserNotifier.value =
            user; // where 'user' is the signed-in UserEntity

        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      signOut;
      emit(Unauthenticated());
    });

    on<AuthCheckRequested>((event, emit) async {
      final user = await getCurrentUser();
      if (user != null) {
        currentUserNotifier.value =
            user; // where 'user' is the signed-in UserEntity
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
