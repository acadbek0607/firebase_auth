import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';

abstract class InvoiceRepository {
  Future<void> createInvoice(InvoiceEntity invoice);
  Future<void> updateInvoice(InvoiceEntity invoice);
  Future<void> deleteInvoice(String id);
  Future<List<InvoiceEntity>> getInvoices();
}
