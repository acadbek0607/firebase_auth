import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_auth/core/utils/status.dart';
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

  final List<InvoiceEntity> _allInvoices = [];

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
    on<FilterInvoicesEvent>(_onFilterInvoices);
    on<SetIsLoadingMore>((event, emit) {
      emit(state.copyWith(isLoadingMore: event.isLoadingMore));
    });
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    if (event.startAfterDoc != null) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(status: InvoiceStatus.loading, errorMessage: null));
      _allInvoices.clear();
    }
    try {
      final res = await getInvoices(
        day: event.day,
        statuses: event.statuses,
        fromDate: event.fromDate,
        toDate: event.toDate,
        startAfterDoc: event.startAfterDoc,
        limit: event.limit,
      );

      final invoices = res.invoices;
      final lastDoc = res.lastDoc;
      final canLoadMore = invoices.length == event.limit;

      _allInvoices.addAll(invoices);

      emit(
        state.copyWith(
          status: InvoiceStatus.loaded,
          invoices: event.startAfterDoc != null
              ? [...state.invoices, ...invoices]
              : invoices,
          isLoadingMore: false,
          canLoadMore: canLoadMore,
          lastDocSnap: lastDoc,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: InvoiceStatus.error, errorMessage: e.toString()),
      );
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
      emit(state.copyWith(errorMessage: e.toString()));
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
      emit(state.copyWith(errorMessage: e.toString()));
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
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onFilterInvoices(
    FilterInvoicesEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    List<InvoiceEntity> filtered = _allInvoices;

    if (event.status != null) {
      filtered = filtered.where((inv) => inv.status == event.status).toList();
    }

    if (event.from != null) {
      filtered = filtered
          .where((inv) => inv.createdAt.isAfter(event.from!))
          .toList();
    }

    if (event.to != null) {
      filtered = filtered
          .where((inv) => inv.createdAt.isBefore(event.to!))
          .toList();
    }

    emit(state.copyWith(status: InvoiceStatus.loaded, invoices: filtered));
  }
}
