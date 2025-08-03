import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_model.dart';
import 'package:fire_auth/features/invoice/data/models/invoice_query_result.dart';
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

      // Update the counter value, creating the document if it doesn't exist
      transaction.set(counterRef, {
        'invoice_id': newId,
      }, SetOptions(merge: true));

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
  Future<InvoiceQueryResult> getInvoices({
    DateTime? day,
    List<StatusType>? statuses,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    var query = firestore
        .collection('invoices')
        .orderBy('created_at', descending: false);

    if (day != null) {
      final start = DateTime(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));
      query = query
          .where(
            'created_at',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
          )
          .where('created_at', isLessThan: Timestamp.fromDate(end));
    }

    if (statuses != null && statuses.isNotEmpty) {
      if (statuses.length == 1) {
        query = query.where(
          'status',
          isEqualTo: statuses.first.toFirestoreString(),
        );
      } else if (statuses.length < 10) {
        query = query.where(
          'status',
          whereIn: statuses.map((s) => s.toFirestoreString()).toList(),
        );
      }
    }

    if (fromDate != null) {
      query = query.where(
        'created_at',
        isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate),
      );
    }
    if (toDate != null) {
      query = query.where(
        'created_at',
        isLessThanOrEqualTo: Timestamp.fromDate(toDate),
      );
    }

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }

    query = query.limit(limit);

    final snap = await query.get();
    final invoices = snap.docs
        .map((doc) => InvoiceModel.fromJson(doc.data(), doc.id))
        .toList();
    final lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    return InvoiceQueryResult(invoices: invoices, lastDoc: lastDoc);
  }
}
