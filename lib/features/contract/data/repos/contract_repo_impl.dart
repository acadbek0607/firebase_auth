import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/data/datasources/contract_remote_data_source.dart';
import 'package:fire_auth/features/contract/data/models/contract_model.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/entities/paginated_contracts.dart';
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
  Future<PaginatedContracts> getContracts({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    final result = await _dataSource.getContracts(
      day: day,
      statuses: statuses,
      fromDate: fromDate,
      toDate: toDate,
      startAfterDoc: startAfterDoc,
      limit: limit,
    );
    final entities = result.contracts.map((m) => m.toEntity()).toList();
    return PaginatedContracts(contracts: entities, lastDoc: result.lastDoc);
  }

  @override
  Future<List<ContractEntity>> getContractsByIds(List<String> ids) async {
    final models = await _dataSource.getContractsByIds(ids);
    return models.map((m) => m.toEntity()).toList();
  }
}
