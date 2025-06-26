import 'package:fire_auth/features/contract/data/datasources/contract_remote_data_source.dart';
import 'package:fire_auth/features/contract/data/models/contract_model.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource _dataSource;

  ContractRepositoryImpl(this._dataSource);

  @override
  Future<void> createContract(ContractEntity contract) async {
    final model = ContractModel.fromEntity(contract);
    await _dataSource.createContract(model);
  }

  @override
  Future<void> updateContract(ContractEntity contract) async {
    if (contract.id == null) throw Exception("Contract ID is null");
    final model = ContractModel.fromEntity(contract);
    await _dataSource.updateContract(contract, model.toJson());
  }

  @override
  Future<void> deleteContract(String contractId) async {
    await _dataSource.deleteContract(contractId);
  }

  @override
  Future<List<ContractEntity>> getContracts() async {
    final models = await _dataSource.getContracts();
    return models.map((model) => model.toEntity()).toList();
  }
}
