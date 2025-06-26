import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class DeleteInvoice {
  final InvoiceRepository repository;

  DeleteInvoice(this.repository);

  Future<void> call(String id) => repository.deleteInvoice(id);
}
