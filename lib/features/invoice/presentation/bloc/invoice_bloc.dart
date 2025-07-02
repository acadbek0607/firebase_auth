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
  }) : super(InvoiceState.initial()) {
    on<LoadInvoices>(_onLoadInvoices);
    on<CreateInvoiceEvent>(_onCreateInvoice);
    on<UpdateInvoiceEvent>(_onUpdateInvoice);
    on<DeleteInvoiceEvent>(_onDeleteInvoice);
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceStatus.loading, errorMesaage: null));
    try {
      final invoices = await getInvoices();
      emit(state.copyWith(status: InvoiceStatus.loaded, invoices: invoices));
    } catch (e) {
      emit(state.copyWith(errorMesaage: e.toString()));
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
      emit(state.copyWith(errorMesaage: e.toString()));
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
      emit(state.copyWith(errorMesaage: e.toString()));
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
      emit(state.copyWith(errorMesaage: e.toString()));
    }
  }
}
