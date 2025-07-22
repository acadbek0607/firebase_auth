import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/contract/domain/entities/paginated_contracts.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class GetContractsByFullName {
  final ContractRepository _repo;
  GetContractsByFullName(this._repo);

  Future<PaginatedContracts> call({
    required String fullName,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) {
    return _repo.getContractsByFullName(
      fullName: fullName,
      startAfterDoc: startAfterDoc,
      limit: limit,
    );
  }
}
