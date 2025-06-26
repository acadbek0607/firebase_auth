import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

List<ContractEntity> enrichContracts(List<ContractEntity> contracts) {
  final Map<String, List<ContractEntity>> grouped = {};

  for (final contract in contracts) {
    grouped.putIfAbsent(contract.fullName, () => []).add(contract);
  }

  return contracts.map((contract) {
    final related = grouped[contract.fullName]!;
    related.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return contract.copyWith(
      contractCount: related.length,
      lastContractId: related.first.id,
    );
  }).toList();
}
