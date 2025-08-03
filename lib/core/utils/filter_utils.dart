import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/widgets/filters.dart';

class FilterUtils {
  static List<ContractEntity> apply(
    List<ContractEntity> contracts,
    Filters filter,
  ) {
    return contracts.where((contract) {
      final statusMatch =
          filter.statuses.isEmpty || filter.statuses.contains(contract.status);
      final fromMatch =
          filter.fromDate == null ||
          !contract.createdAt.isBefore(filter.fromDate!);
      final toMatch =
          filter.toDate == null ||
          contract.createdAt.isBefore(
            filter.toDate!.add(const Duration(days: 1)),
          );
      return statusMatch && fromMatch && toMatch;
    }).toList();
  }
}
