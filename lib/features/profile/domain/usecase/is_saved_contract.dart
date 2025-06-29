import 'package:fire_auth/features/profile/domain/repos/profile_repo.dart';

class IsContractSaved {
  final ProfileRepo repo;

  IsContractSaved(this.repo);

  Future<bool> call(String uid, String contractId) =>
      repo.isContractSaved(uid, contractId);
}
