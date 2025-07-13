part of 'contract_bloc.dart';

abstract class ContractEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadContracts extends ContractEvent {
  final DateTime? day;
  final List<StatusType>? statuses;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DocumentSnapshot? startAfterDoc;
  final int limit;

  LoadContracts({
    this.day,
    this.statuses,
    this.fromDate,
    this.toDate,
    this.startAfterDoc,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [
    day,
    statuses,
    fromDate,
    toDate,
    startAfterDoc,
    limit,
  ];
}

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

class SetIsLoadingMore extends ContractEvent {
  final bool isLoadingMore;
  SetIsLoadingMore(this.isLoadingMore);
}
