import 'package:fire_auth/core/utils/status.dart';

class InvoiceEntity {
  final String? id; // optional
  final String serviceName;
  final double cost;
  final StatusType
  status; // paid, in_process, rejected_by_iq, rejected_by_payme
  final DateTime createdAt;

  InvoiceEntity({
    this.id,
    required this.serviceName,
    required this.cost,
    required this.status,
    required this.createdAt,
  });

  InvoiceEntity copyWith({
    String? id,
    String? serviceName,
    double? cost,
    StatusType? status,
    DateTime? createdAt,
  }) {
    return InvoiceEntity(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
