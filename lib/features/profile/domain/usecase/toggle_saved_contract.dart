import 'package:fire_auth/features/profile/domain/repos/profile_repo.dart';

class ToggleSavedContract {
  final ProfileRepo repo;

  ToggleSavedContract(this.repo);

  Future<void> call(String uid, String contractId) =>
      repo.toggleSavedContract(uid, contractId);
}
