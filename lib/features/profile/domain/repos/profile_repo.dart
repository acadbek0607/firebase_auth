import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepo {
  Future<void> createOrUpdateProfile(ProfileEntity profile);
  Future<ProfileEntity?> getProfile(String uid);
  Future<void> toggleSavedContract(String uid, String contractId);
  Future<bool> isContractSaved(String uid, String contractId);
}
