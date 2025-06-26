import 'package:fire_auth/core/utils/status.dart';

class ContractEntity {
  final String? id;
  final String type;
  final String fullName;
  final StatusType status;
  final double amount;
  final String organizationAddress;
  final String inn;
  final DateTime createdAt;
  // UI-helper fields (optional)
  final int? contractCount;
  final String? lastContractId;

  ContractEntity({
    this.id,
    required this.type,
    required this.fullName,
    required this.status,
    required this.amount,
    required this.organizationAddress,
    required this.inn,
    required this.createdAt,
    this.contractCount,
    this.lastContractId,
  });

  ContractEntity copyWith({
    String? id,
    String? type,
    String? fullName,
    StatusType? status,
    double? amount,
    String? organizationAddress,
    String? inn,
    DateTime? createdAt,
    int? contractCount,
    String? lastContractId,
  }) {
    return ContractEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      organizationAddress: organizationAddress ?? this.organizationAddress,
      inn: inn ?? this.inn,
      createdAt: createdAt ?? this.createdAt,
      contractCount: contractCount ?? this.contractCount,
      lastContractId: lastContractId ?? this.lastContractId,
    );
  }
}
