part of 'saved_bloc.dart';

class SavedContractsState extends Equatable {
  final BlocStatus status;
  final List<ContractEntity> contracts;
  final int nextIndex;
  final bool canLoadMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const SavedContractsState({
    this.status = BlocStatus.initial,
    this.contracts = const [],
    this.nextIndex = 0,
    this.canLoadMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  SavedContractsState copyWith({
    BlocStatus? status,
    List<ContractEntity>? contracts,
    int? nextIndex,
    bool? canLoadMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return SavedContractsState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      nextIndex: nextIndex ?? this.nextIndex,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    contracts,
    nextIndex,
    canLoadMore,
    isLoadingMore,
    errorMessage,
  ];
}
