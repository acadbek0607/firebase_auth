part of 'contract_bloc.dart';

@immutable
sealed class ContractState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContractInitial extends ContractState {}

class ContractLoading extends ContractState {}

class ContractLoaded extends ContractState {
  final List<ContractEntity> contracts;

  ContractLoaded(this.contracts);

  @override
  List<Object?> get props => [contracts];
}

class ContractError extends ContractState {
  final String message;

  ContractError(this.message);

  @override
  List<Object?> get props => [message];
}
