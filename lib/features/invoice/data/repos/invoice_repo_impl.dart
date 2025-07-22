import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/data/datasources/invoice_remote_data_source.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/entities/paginated_invoices.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createInvoice(InvoiceEntity invoice) async {
    final model = InvoiceModel.fromEntity(invoice);
    await remoteDataSource.createInvoice(model);
  }

  @override
  Future<void> updateInvoice(InvoiceEntity invoice) async {
    final model = InvoiceModel.fromEntity(invoice);
    await remoteDataSource.updateInvoice(model, model.toJson());
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await remoteDataSource.deleteInvoice(id);
  }

  @override
  Future<PaginatedInvoices> getInvoices({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    final result = await remoteDataSource.getInvoices(
      day: day,
      statuses: statuses,
      fromDate: fromDate,
      toDate: toDate,
      startAfterDoc: startAfterDoc,
      limit: limit,
    );
    final entities = result.invoices.map((m) => m.toEntity()).toList();
    return PaginatedInvoices(invoices: entities, lastDoc: result.lastDoc);
  }
}
