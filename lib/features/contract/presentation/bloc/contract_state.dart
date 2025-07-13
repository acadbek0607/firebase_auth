// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'contract_bloc.dart';

class ContractState extends Equatable {
  final BlocStatus status;
  final List<ContractEntity> contracts;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool canLoadMore;
  final DocumentSnapshot? lastDocSnap;

  const ContractState({
    this.status = BlocStatus.initial,
    required this.contracts,
    this.errorMessage,
    this.isLoadingMore = false,
    this.canLoadMore = true,
    this.lastDocSnap,
  });

  factory ContractState.initial() {
    return const ContractState(
      contracts: [],
      errorMessage: null,
      canLoadMore: true,
      isLoadingMore: false,
      lastDocSnap: null,
    );
  }

  ContractState copyWith({
    BlocStatus? status,
    List<ContractEntity>? contracts,
    String? errorMessage,
    bool? isLoadingMore,
    bool? canLoadMore,
    DocumentSnapshot? lastDocSnap,
  }) {
    return ContractState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      errorMessage: errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
    );
  }

  @override
  List<Object?> get props => [
    status,
    contracts,
    errorMessage,
    isLoadingMore,
    canLoadMore,
    lastDocSnap,
  ];
}
