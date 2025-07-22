import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class CreateContract {
  final ContractRepository repository;

  CreateContract(this.repository);

  Future<String> call(ContractEntity contract) =>
      repository.createContract(contract);
}
