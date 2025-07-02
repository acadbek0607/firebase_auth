part of 'invoice_bloc.dart';

class InvoiceState extends Equatable {
  final InvoiceStatus status;
  final List<InvoiceEntity> invoices;
  final String? errorMessage;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    required this.invoices,
    this.errorMessage,
  });

  factory InvoiceState.initial() {
    return InvoiceState(invoices: [], errorMessage: null);
  }

  InvoiceState copyWith({
    InvoiceStatus? status,
    List<InvoiceEntity>? invoices,
    String? errorMesaage,
  }) {
    return InvoiceState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      errorMessage: errorMesaage,
    );
  }

  @override
  List<Object?> get props => [status, invoices, errorMessage];
}

enum InvoiceStatus { initial, loading, loaded, error }
