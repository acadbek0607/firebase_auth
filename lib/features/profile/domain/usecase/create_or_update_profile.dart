import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/domain/repos/profile_repo.dart';

class CreateOrUpdateProfile {
  final ProfileRepo repo;

  CreateOrUpdateProfile(this.repo);

  Future<void> call(ProfileEntity profile) =>
      repo.createOrUpdateProfile(profile);
}
