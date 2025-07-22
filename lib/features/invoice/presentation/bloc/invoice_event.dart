part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoices extends InvoiceEvent {
  final DateTime? day;
  final List<StatusType>? statuses;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DocumentSnapshot? startAfterDoc;
  final int limit;

  const LoadInvoices({
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

class FilterInvoicesEvent extends InvoiceEvent {
  final StatusType? status;
  final DateTime? from;
  final DateTime? to;

  const FilterInvoicesEvent({this.status, this.from, this.to});
}

class SetIsLoadingMore extends InvoiceEvent {
  final bool isLoadingMore;
  const SetIsLoadingMore(this.isLoadingMore);
}

class CreateInvoiceEvent extends InvoiceEvent {
  final InvoiceEntity invoice;

  const CreateInvoiceEvent(this.invoice);
}

class UpdateInvoiceEvent extends InvoiceEvent {
  final InvoiceEntity invoice;

  const UpdateInvoiceEvent(this.invoice);
}

class DeleteInvoiceEvent extends InvoiceEvent {
  final String invoiceId;

  const DeleteInvoiceEvent(this.invoiceId);
}
