import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';
import 'package:fire_auth/features/contract/domain/usecases/get_contracts_count_by_fullname.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ContractCard extends StatelessWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;
  final VoidCallback? onTap;
  final bool openFromDetail;

  const ContractCard({
    super.key,
    required this.contract,
    required this.allContracts,
    this.onTap,
    this.openFromDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = KFormat.amountFormat.format(contract.amount);
    final formattedDate = KFormat.dateFormat.format(contract.createdAt);

    // Filter contracts belonging to the same fullName
    final relatedContracts = allContracts
        .where((c) => c.fullName == contract.fullName)
        .toList();

    // Sort by createdAt to find the last one
    relatedContracts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final lastContractId = relatedContracts.isNotEmpty
        ? relatedContracts.first.id ?? '—'
        : '—';

    final countFuture = GetContractsCountByFullName(
      context.read<ContractRepository>(),
    )(contract.fullName);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(
              context,
              '/contract_detail',
              arguments: {
                'contract': contract,
                'allContracts': relatedContracts,
                'fromDetail': openFromDetail,
              },
            );
          },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.fromLTRB(10, 12, 12, 12),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(6.0),
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
                    SvgPicture.asset('assets/svg/contract.svg', height: 21.0),
                    SizedBox(width: 8),
                    Text(
                      '№ ${contract.id ?? '—'}',
                      style: Kstyle.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
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
                    contract.status.label(context),
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
                text: tr('fish', context: context),
                style: Kstyle.textStyle,
                children: [
                  TextSpan(
                    text: contract.fullName,
                    style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: tr('amount', context: context),
                style: Kstyle.textStyle,
                children: [
                  TextSpan(
                    text:
                        '$formattedAmount ${tr('currency', context: context)}',
                    style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: tr('last_contract', context: context),
                style: Kstyle.textStyle,
                children: [
                  TextSpan(
                    text: '№ $lastContractId',
                    style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<int>(
                  future: countFuture,
                  builder: (context, snapshot) {
                    final total = snapshot.data ?? relatedContracts.length + 1;
                    return Text.rich(
                      TextSpan(
                        text: tr('number_of_contracts', context: context),
                        style: Kstyle.textStyle,
                        children: [
                          TextSpan(
                            text: '$total',
                            style: Kstyle.textStyle.copyWith(
                              color: AppColors.cardGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Text(
                  formattedDate,
                  style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
