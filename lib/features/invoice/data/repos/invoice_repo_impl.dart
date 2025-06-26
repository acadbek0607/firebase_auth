import 'package:fire_auth/features/invoice/data/datasources/invoice_remote_data_source.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/domain/repos/invoice_repo.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createInvoice(InvoiceEntity invoice) async {
    final model = InvoiceModel.fromEntity(invoice);
    await remoteDataSource.createInvoice(model);
  }

  @override
  Future<void> updateInvoice(InvoiceEntity invoice) async {
    final model = InvoiceModel.fromEntity(invoice);
    await remoteDataSource.updateInvoice(model, model.toJson());
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await remoteDataSource.deleteInvoice(id);
  }

  @override
  Future<List<InvoiceEntity>> getInvoices() async {
    final models = await remoteDataSource.getInvoices();
    return models.map((model) => model.toEntity()).toList();
  }
}
