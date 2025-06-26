import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class CreateInvoice {
  final InvoiceRepository repository;

  CreateInvoice(this.repository);

  Future<void> call(InvoiceEntity invoice) => repository.createInvoice(invoice);
}
