import 'package:fire_auth/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fire_auth/features/auth/domain/entities/user_entity.dart';
import 'package:fire_auth/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource dataSource;

  AuthRepoImpl(this.dataSource);

  @override
  Future<UserEntity?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) {
    return dataSource.signInWithEmail(email, password);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password) {
    return dataSource.signUpWithEmail(email, password);
  }
}
