import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContractCard extends StatelessWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;
  final VoidCallback? onTap;

  const ContractCard({
    super.key,
    required this.contract,
    required this.allContracts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Filter contracts belonging to the same fullName
    final relatedContracts = allContracts
        .where((c) => c.fullName == contract.fullName)
        .toList();

    // Sort by createdAt to find the last one
    relatedContracts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final lastContractId = relatedContracts.isNotEmpty
        ? relatedContracts.first.id ?? '—'
        : '—';

    final totalContracts = relatedContracts.length;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/contract_detail',
          arguments: {'contract': contract, 'allContracts': relatedContracts},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svg/contract.svg'),
                    SizedBox(width: 8),
                    Text(
                      '№ ${contract.id ?? '—'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: contract.status.color.withAlpha(44),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contract.status.label,
                    style: Kstyle.textStyle.copyWith(
                      color: contract.status.color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: 'Fisher: ',
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: contract.fullName,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Amount: ',
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: '''${contract.amount.toString()} so'm''',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Last contract: ',
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: '№ $lastContractId',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Number of contracts: ',
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: '$totalContracts',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${contract.createdAt.day}/${contract.createdAt.month}/${contract.createdAt.year}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
