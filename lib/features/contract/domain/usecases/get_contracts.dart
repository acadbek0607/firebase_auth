import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/paginated_contracts.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class GetContracts {
  final ContractRepository repository;

  GetContracts(this.repository);

  Future<PaginatedContracts> call({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) => repository.getContracts(
    day: day,
    statuses: statuses,
    fromDate: fromDate,
    toDate: toDate,
    startAfterDoc: startAfterDoc,
    limit: limit,
  );
}
