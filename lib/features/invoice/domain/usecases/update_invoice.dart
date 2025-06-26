import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class UpdateInvoice {
  final InvoiceRepository repository;

  UpdateInvoice(this.repository);

  Future<void> call(InvoiceEntity invoice) {
    return repository.updateInvoice(invoice);
  }
}
