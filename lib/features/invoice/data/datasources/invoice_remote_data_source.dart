import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoiceRemoteDataSource {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoice(InvoiceEntity invoice, Map<String, dynamic> json);
  Future<void> deleteInvoice(String invoiceId);
  Future<List<InvoiceModel>> getInvoices();
}
