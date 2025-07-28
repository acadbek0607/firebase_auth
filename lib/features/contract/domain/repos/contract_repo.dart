import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/paginated_contracts.dart';

import '../entities/contract_entity.dart';

abstract class ContractRepository {
  Future<String> createContract(ContractEntity contract);
  Future<void> updateContract(ContractEntity contract);
  Future<void> deleteContract(String contractId);
  Future<PaginatedContracts> getContracts({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit,
  });
  Future<List<ContractEntity>> getContractsByIds(List<String> ids);

  Future<PaginatedContracts> getContractsByFullName({
    required String fullName,
    DocumentSnapshot? startAfterDoc,
    int limit,
  });

  Future<int> countContractsByFullName(String fullName);
}
