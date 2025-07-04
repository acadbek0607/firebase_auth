import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/widgets/filter_widget.dart';

class FilterUtils {
  static List<ContractEntity> apply(
    List<ContractEntity> contracts,
    FilterWidget filter,
  ) {
    return contracts.where((contract) {
      final statusMatch =
          filter.statuses.isEmpty || filter.statuses.contains(contract.status);
      final fromMatch =
          filter.fromDate == null ||
          !contract.createdAt.isBefore(filter.fromDate!);
      final toMatch =
          filter.toDate == null || !contract.createdAt.isAfter(filter.toDate!);
      return statusMatch && fromMatch && toMatch;
    }).toList();
  }
}
