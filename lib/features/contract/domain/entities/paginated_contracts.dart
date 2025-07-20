// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class PaginatedContracts {
  final List<ContractEntity> contracts;
  final DocumentSnapshot? lastDoc;
  PaginatedContracts({required this.contracts, required this.lastDoc});
}
