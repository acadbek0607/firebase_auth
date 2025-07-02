// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contract_bloc.dart';

class ContractState extends Equatable {
  final BlocStatus status;
  final List<ContractEntity> contracts;
  final String? errorMessage;

  const ContractState({
    this.status = BlocStatus.initial,
    required this.contracts,
    this.errorMessage,
  });

  factory ContractState.initial() {
    return const ContractState(contracts: [], errorMessage: null);
  }

  ContractState copyWith({
    BlocStatus? status,
    List<ContractEntity>? contracts,
    String? errorMessage,
  }) {
    return ContractState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, contracts, errorMessage];
}
