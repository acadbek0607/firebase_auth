import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_query_result.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoiceRemoteDataSource {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoice(InvoiceEntity invoice, Map<String, dynamic> json);
  Future<void> deleteInvoice(String invoiceId);
  Future<InvoiceQueryResult> getInvoices({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit,
  });
}
