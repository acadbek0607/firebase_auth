import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class DeleteContract {
  final ContractRepository repository;

  DeleteContract(this.repository);

  Future<void> call(String id) => repository.deleteContract(id);
}
