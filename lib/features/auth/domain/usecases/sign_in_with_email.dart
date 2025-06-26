import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/repos/auth_repo.dart';

class SignInWithEmail {
  final AuthRepo authRepo;

  SignInWithEmail(this.authRepo);

  Future<UserEntity> call(String email, String password) {
    return authRepo.signInWithEmail(email, password);
  }
}
