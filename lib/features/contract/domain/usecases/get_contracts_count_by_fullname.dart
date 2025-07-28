import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class GetContractsCountByFullName {
  final ContractRepository _repo;
  GetContractsCountByFullName(this._repo);

  Future<int> call(String fullName) {
    return _repo.countContractsByFullName(fullName);
  }
}
