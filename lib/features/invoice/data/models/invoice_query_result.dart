import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';

class InvoiceQueryResult {
  final List<InvoiceModel> invoices;
  final DocumentSnapshot? lastDoc;

  InvoiceQueryResult({required this.invoices, required this.lastDoc});
}
