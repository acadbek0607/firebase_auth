part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoices extends InvoiceEvent {}

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
