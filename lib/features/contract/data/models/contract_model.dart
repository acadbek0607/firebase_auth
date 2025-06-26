import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  ContractModel({
    required super.id,
    required super.type,
    required super.fullName,
    required super.organizationAddress,
    required super.inn,
    required super.status,
    required super.amount,
    required super.createdAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json, String id) {
    return ContractModel(
      id: id,
      type: json['type'] ?? '',
      fullName: json['fullName'] ?? '',
      organizationAddress: json['organizationAddress'] ?? '',
      inn: json['inn'] ?? '',
      status: StatusTypeExtension.fromString(json['status'] ?? ''),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'fullName': fullName,
      'organizationAddress': organizationAddress,
      'inn': inn,
      'status': status.toFirestoreString(),
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  factory ContractModel.fromEntity(ContractEntity entity) {
    return ContractModel(
      id: entity.id,
      type: entity.type,
      fullName: entity.fullName,
      organizationAddress: entity.organizationAddress,
      inn: entity.inn,
      status: entity.status,
      amount: entity.amount,
      createdAt: entity.createdAt,
    );
  }

  ContractEntity toEntity() => this;
}
