part of 'related_bloc.dart';

class RelatedState extends Equatable {
  final BlocStatus status;
  final List<ContractEntity> relatedContracts;
  final bool isLoadingMore;
  final bool canLoadMore;
  final DocumentSnapshot? lastDocSnap;
  final String? errorMessage;

  const RelatedState({
    this.status = BlocStatus.initial,
    this.relatedContracts = const [],
    this.isLoadingMore = false,
    this.canLoadMore = true,
    this.lastDocSnap,
    this.errorMessage,
  });

  RelatedState copyWith({
    BlocStatus? status,
    List<ContractEntity>? relatedContracts,
    bool? isLoadingMore,
    bool? canLoadMore,
    DocumentSnapshot? lastDocSnap,
    String? errorMessage,
  }) {
    return RelatedState(
      status: status ?? this.status,
      relatedContracts: relatedContracts ?? this.relatedContracts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    relatedContracts,
    isLoadingMore,
    canLoadMore,
    lastDocSnap ?? '',
    errorMessage ?? '',
  ];
}

final class RelatedInitial extends RelatedState {}
