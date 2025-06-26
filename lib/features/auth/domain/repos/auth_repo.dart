import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
