import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/data/models/contract_model.dart';
import 'package:fire_auth/features/contract/data/models/contract_query_result.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'contract_remote_data_source.dart';

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final FirebaseFirestore firestore;

  ContractRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createContract(ContractEntity contract) async {
    final counterRef = firestore.collection('meta').doc('counters');

    await firestore.runTransaction((transaction) async {
      final counterSnap = await transaction.get(counterRef);

      int currentId = 0;
      if (counterSnap.exists) {
        currentId = counterSnap.data()?['contract_id'] ?? 0;
      }

      final newId = currentId + 1;

      // Update the counter value
      transaction.update(counterRef, {'contract_id': newId});

      // Save contract with numeric ID
      final model = ContractModel.fromEntity(
        contract.copyWith(id: newId.toString()),
      );

      final docRef = firestore.collection('contracts').doc(newId.toString());
      transaction.set(docRef, model.toJson());
    });
  }

  @override
  Future<void> updateContract(
    ContractEntity contract,
    Map<String, dynamic> json,
  ) async {
    if (contract.id == null) throw Exception("Contract ID is null");
    await firestore.collection('contracts').doc(contract.id).update(json);
  }

  @override
  Future<void> deleteContract(String contractId) async {
    await firestore.collection('contracts').doc(contractId).delete();
  }

  @override
  Future<ContractQueryResult> getContracts({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    var query = firestore
        .collection('contracts')
        .orderBy('createdAt', descending: false);

    if (day != null) {
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(Duration(days: 1));

      query = query
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThan: Timestamp.fromDate(end));
    }

    if (statuses != null && statuses.isNotEmpty) {
      if (statuses.length == 1) {
        query = query.where(
          'status',
          isEqualTo: statuses.first.toFirestoreString(),
        );
      } else if (statuses.length < 10) {
        query = query.where(
          'status',
          whereIn: statuses.map((s) => s.toFirestoreString()).toList(),
        );
      }
    }

    if (fromDate != null) {
      query = query.where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
      );
    }
    if (toDate != null) {
      query = query.where(
        'createdAt',
        isLessThanOrEqualTo: Timestamp.fromDate(toDate),
      );
    }
    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }
    query = query.limit(limit);

    final snap = await query.get();
    final contracts = snap.docs
        .map((doc) => ContractModel.fromJson(doc.data(), doc.id))
        .toList();
    final lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    return ContractQueryResult(contracts: contracts, lastDoc: lastDoc);
  }

  @override
  Future<List<ContractModel>> getContractsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snap = await firestore
        .collection('contracts')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snap.docs
        .map((doc) => ContractModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<ContractQueryResult> getContractsByFullName({
    required String fullName,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    var query = firestore
        .collection('contracts')
        .where('fullName', isEqualTo: fullName)
        .orderBy('createdAt', descending: false);

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }

    query = query.limit(limit);

    final snap = await query.get();
    final contracts = snap.docs
        .map((doc) => ContractModel.fromJson(doc.data(), doc.id))
        .toList();
    final lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    return ContractQueryResult(contracts: contracts, lastDoc: lastDoc);
  }
}
