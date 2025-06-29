import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/domain/repos/profile_repo.dart';

class GetProfile {
  final ProfileRepo repo;

  GetProfile(this.repo);

  Future<ProfileEntity?> call(String uid) => repo.getProfile(uid);
}
