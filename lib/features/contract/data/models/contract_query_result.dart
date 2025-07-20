import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/contract/data/models/contract_model.dart';

class ContractQueryResult {
  final List<ContractModel> contracts;
  final DocumentSnapshot? lastDoc;

  ContractQueryResult({required this.contracts, required this.lastDoc});
}
