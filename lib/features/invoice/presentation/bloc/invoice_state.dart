part of 'invoice_bloc.dart';

class InvoiceState extends Equatable {
  final InvoiceStatus status;
  final List<InvoiceEntity> invoices;
  final String? errorMessage;
  final bool isLoadingMore;
  final bool canLoadMore;
  final DocumentSnapshot? lastDocSnap;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    required this.invoices,
    this.errorMessage,
    this.isLoadingMore = false,
    this.canLoadMore = true,
    this.lastDocSnap,
  });

  factory InvoiceState.initial() {
    return const InvoiceState(
      invoices: [],
      errorMessage: null,
      isLoadingMore: false,
      canLoadMore: true,
      lastDocSnap: null,
    );
  }

  InvoiceState copyWith({
    InvoiceStatus? status,
    List<InvoiceEntity>? invoices,
    String? errorMessage,
    bool? isLoadingMore,
    bool? canLoadMore,
    DocumentSnapshot? lastDocSnap,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      errorMessage: errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      lastDocSnap: lastDocSnap ?? this.lastDocSnap,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoices,
    errorMessage,
    isLoadingMore,
    canLoadMore,
    lastDocSnap,
  ];
}

enum InvoiceStatus { initial, loading, loaded, error }
