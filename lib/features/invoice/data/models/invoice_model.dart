import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  @override
  // ignore: overridden_fields
  final String id;

  InvoiceModel({
    required this.id,
    required super.serviceName,
    required super.cost,
    required super.status,
    required super.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json, String id) {
    return InvoiceModel(
      id: id,
      serviceName: json['service_name'],
      cost: (json['cost'] as num).toDouble(),
      status: StatusTypeExtension.fromString(json['status']),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'cost': cost,
      'status': status.toFirestoreString(),
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory InvoiceModel.fromEntity(InvoiceEntity entity) {
    return InvoiceModel(
      id: entity.id ?? '',
      serviceName: entity.serviceName,
      cost: entity.cost,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  InvoiceEntity toEntity() {
    return InvoiceEntity(
      id: id,
      serviceName: serviceName,
      cost: cost,
      status: status,
      createdAt: createdAt,
    );
  }
}
