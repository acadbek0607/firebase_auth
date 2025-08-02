// contract_detail_info_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';
import 'package:fire_auth/features/contract/domain/usecases/get_contracts_count_by_fullname.dart';
import 'package:flutter/material.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailInfoCard extends StatelessWidget {
  final ContractEntity contract;
  final List<ContractEntity> allContracts;

  const ContractDetailInfoCard({
    super.key,
    required this.contract,
    required this.allContracts,
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = KFormat.amountFormat.format(contract.amount);

    // Determine last contract id for the same full name
    final related =
        allContracts.where((c) => c.fullName == contract.fullName).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final lastContractId = related.isNotEmpty ? related.first.id ?? '—' : '—';

    // Fetch total number of contracts for this full name
    final countFuture = GetContractsCountByFullName(
      context.read<ContractRepository>(),
    )(contract.fullName);

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        color: AppColors.darker,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailText(
                tr('fisher', context: context),
                ' ${contract.fullName}',
              ),
              _detailText(
                tr('status_of_contract', context: context),
                ' ${contract.status.label(context)}',
              ),
              _detailText(
                tr('amount', context: context),
                '$formattedAmount ${tr('currency', context: context)}',
              ),
              _detailText(tr('last_contract'), ' № $lastContractId'),
              FutureBuilder<int>(
                future: countFuture,
                builder: (context, snapshot) {
                  final total = snapshot.data ?? related.length;
                  return _detailText(tr('number_of_contracts'), ' $total');
                },
              ),
              _detailText(
                tr('address', context: context),
                ' ${contract.organizationAddress}',
              ),
              _detailText(tr('itn', context: context), ' ${contract.inn}'),
              _detailText(
                tr('created_at', context: context),
                ' ${KFormat.dateFormat.format(contract.createdAt)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title ',
              style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: value,
              style: Kstyle.textStyle.copyWith(
                color: AppColors.cardGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
