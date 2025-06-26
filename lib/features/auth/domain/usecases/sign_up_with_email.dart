import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/repos/auth_repo.dart';

class SignUpWithEmail {
  final AuthRepo authRepo;

  SignUpWithEmail(this.authRepo);

  Future<UserEntity> call(String email, String password) {
    return authRepo.signUpWithEmail(email, password);
  }
}
