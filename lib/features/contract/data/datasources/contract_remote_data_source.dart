import 'package:fire_auth/features/contract/data/models/contract_model.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

abstract class ContractRemoteDataSource {
  Future<void> createContract(ContractEntity contract);
  Future<void> updateContract(
    ContractEntity contract,
    Map<String, dynamic> json,
  );
  Future<void> deleteContract(String contractId);
  Future<List<ContractModel>> getContracts();
}
