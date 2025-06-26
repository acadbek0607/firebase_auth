import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class PaginatedContracts {
  final List<ContractEntity> items;
  final DocumentSnapshot? lastDoc;
  final bool hasMore;

  PaginatedContracts({
    required this.items,
    required this.lastDoc,
    required this.hasMore,
  });
}
