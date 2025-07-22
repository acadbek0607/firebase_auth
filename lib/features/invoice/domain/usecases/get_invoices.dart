import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/domain/entities/paginated_invoices.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class GetInvoices {
  final InvoiceRepository repository;

  GetInvoices(this.repository);

  Future<PaginatedInvoices> call({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) => repository.getInvoices(
    day: day,
    statuses: statuses,
    fromDate: fromDate,
    toDate: toDate,
    startAfterDoc: startAfterDoc,
    limit: limit,
  );
}
