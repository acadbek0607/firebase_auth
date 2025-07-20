import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/paginated_contracts.dart';

import '../entities/contract_entity.dart';

abstract class ContractRepository {
  Future<void> createContract(ContractEntity contract);
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
}
