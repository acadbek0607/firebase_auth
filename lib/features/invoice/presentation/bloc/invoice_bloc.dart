import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/usecases/invoice_usecases.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final CreateInvoice createInvoice;
  final UpdateInvoice updateInvoice;
  final DeleteInvoice deleteInvoice;
  final GetInvoices getInvoices;

  InvoiceBloc({
    required this.createInvoice,
    required this.updateInvoice,
    required this.deleteInvoice,
    required this.getInvoices,
  }) : super(InvoiceInitial()) {
    on<LoadInvoices>(_onLoadInvoices);
    on<CreateInvoiceEvent>(_onCreateInvoice);
    on<UpdateInvoiceEvent>(_onUpdateInvoice);
    on<DeleteInvoiceEvent>(_onDeleteInvoice);
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoading());
    try {
      final invoices = await getInvoices();
      emit(InvoiceLoaded(invoices));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onCreateInvoice(
    CreateInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await createInvoice(event.invoice);
      add(LoadInvoices());
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onUpdateInvoice(
    UpdateInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await updateInvoice(event.invoice);
      add(LoadInvoices());
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onDeleteInvoice(
    DeleteInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await deleteInvoice(event.invoiceId);
      add(LoadInvoices());
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
