// lib/features/contract/domain/entities/contract_filter.dart
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class FilterWidget {
  final List<StatusType> statuses;
  final DateTime? fromDate;
  final DateTime? toDate;

  const FilterWidget({this.statuses = const [], this.fromDate, this.toDate});

  List<ContractEntity> apply(List<ContractEntity> contracts) {
    return contracts.where((contract) {
      final statusMatch =
          statuses.isEmpty || statuses.contains(contract.status);
      final created = contract.createdAt;
      final dateMatch =
          (fromDate == null || !created.isBefore(fromDate!)) &&
          (toDate == null || !created.isAfter(toDate!));
      return statusMatch && dateMatch;
    }).toList();
  }

  static const empty = FilterWidget();
}
