import '../entities/contract_entity.dart';

abstract class ContractRepository {
  Future<void> createContract(ContractEntity contract);
  Future<void> updateContract(ContractEntity contract);
  Future<void> deleteContract(String contractId);
  Future<List<ContractEntity>> getContracts();
}
