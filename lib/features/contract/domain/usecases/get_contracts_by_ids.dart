import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class GetContractsByIds {
  final ContractRepository _repo;

  GetContractsByIds(this._repo);

  Future<List<ContractEntity>> call(List<String> ids) {
    return _repo.getContractsByIds(ids);
  }
}
