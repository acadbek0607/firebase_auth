import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class GetContracts {
  final ContractRepository repository;

  GetContracts(this.repository);

  Future<List<ContractEntity>> call() => repository.getContracts();
}
