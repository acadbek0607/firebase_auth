import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/entities/paginated_invoices.dart';

abstract class InvoiceRepository {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoice(InvoiceEntity invoice);
  Future<void> deleteInvoice(String id);
  Future<PaginatedInvoices> getInvoices({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit,
  });
}
