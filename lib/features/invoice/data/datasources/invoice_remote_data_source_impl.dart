import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'invoice_remote_data_source.dart';

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final FirebaseFirestore firestore;

  InvoiceRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createInvoice(InvoiceEntity invoice) async {
    final counterRef = firestore.collection('meta').doc('counters');

    await firestore.runTransaction((transaction) async {
      final counterSnap = await transaction.get(counterRef);

      int currentId = 0;
      if (counterSnap.exists) {
        currentId = counterSnap.data()?['invoice_id'] ?? 0;
      }

      final newId = currentId + 1;

      // Update the counter value
      transaction.update(counterRef, {'invoice_id': newId});

      // Save invoice with numeric ID
      final model = InvoiceModel.fromEntity(
        invoice.copyWith(id: newId.toString()),
      );

      final docRef = firestore.collection('invoices').doc(newId.toString());
      transaction.set(docRef, model.toJson());
    });
  }

  @override
  Future<void> updateInvoice(
    InvoiceEntity invoice,
    Map<String, dynamic> json,
  ) async {
    if (invoice.id == null) throw Exception("Invoice ID is null");
    await firestore.collection('invoices').doc(invoice.id).update(json);
  }

  @override
  Future<void> deleteInvoice(String invoiceId) async {
    await firestore.collection('invoices').doc(invoiceId).delete();
  }

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    final snapshot = await firestore.collection('invoices').get();
    return snapshot.docs
        .map((doc) => InvoiceModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
