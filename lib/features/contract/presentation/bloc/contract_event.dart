part of 'contract_bloc.dart';

@immutable
sealed class ContractEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadContracts extends ContractEvent {}

class CreateContractEvent extends ContractEvent {
  final ContractEntity contract;

  CreateContractEvent(this.contract);

  @override
  List<Object?> get props => [contract];
}

class UpdateContractEvent extends ContractEvent {
  final ContractEntity contract;

  UpdateContractEvent(this.contract);

  @override
  List<Object?> get props => [contract];
}

class DeleteContractEvent extends ContractEvent {
  final String contractId;

  DeleteContractEvent(this.contractId);

  @override
  List<Object?> get props => [contractId];
}
