import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/repos/auth_repo.dart';

class GetCurrentUser {
  final AuthRepo authRepo;

  GetCurrentUser(this.authRepo);

  Future<UserEntity?> call() {
    return authRepo.getCurrentUser();
  }
}
