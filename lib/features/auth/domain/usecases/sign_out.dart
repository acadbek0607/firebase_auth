import 'package:fire_auth/features/auth/domain/repos/auth_repo.dart';

class SignOut {
  final AuthRepo authRepo;

  SignOut(this.authRepo);

  Future<void> call() {
    return authRepo.signOut();
  }
}
