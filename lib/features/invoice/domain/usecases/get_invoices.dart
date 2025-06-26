import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class GetInvoices {
  final InvoiceRepository repository;

  GetInvoices(this.repository);

  Future<List<InvoiceEntity>> call() => repository.getInvoices();
}
