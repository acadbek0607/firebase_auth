import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/contract/data/models/contract_model.dart';
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
  Future<List<ContractModel>> getContracts() async {
    final snapshot = await firestore.collection('contracts').get();
    return snapshot.docs
        .map((doc) => ContractModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
