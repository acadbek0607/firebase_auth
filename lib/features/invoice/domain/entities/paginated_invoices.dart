import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';

class PaginatedInvoices {
  final List<InvoiceEntity> invoices;
  final DocumentSnapshot? lastDoc;

  PaginatedInvoices({required this.invoices, required this.lastDoc});
}
