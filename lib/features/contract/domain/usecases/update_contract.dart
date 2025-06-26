import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class UpdateContract {
  final ContractRepository repository;

  UpdateContract(this.repository);

  Future<void> call(ContractEntity contract) {
    return repository.updateContract(contract);
  }
}
