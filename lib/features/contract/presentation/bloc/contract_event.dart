part of 'contract_bloc.dart';

abstract class ContractEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadContracts extends ContractEvent {}

class CreateContractEvent extends ContractEvent {
  final ContractEntity contract;
  CreateContractEvent(this.contract);
}

class UpdateContractEvent extends ContractEvent {
  final ContractEntity contract;
  UpdateContractEvent(this.contract);
}

class DeleteContractEvent extends ContractEvent {
  final String contractId;
  DeleteContractEvent(this.contractId);
}

class FilterContractsEvent extends ContractEvent {
  final StatusType? status;
  final DateTime? from;
  final DateTime? to;

  FilterContractsEvent({this.status, this.from, this.to});
}
