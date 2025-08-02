// contract_detail_info_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class ContractDetailInfoCard extends StatelessWidget {
  final ContractEntity contract;

  const ContractDetailInfoCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final formattedAmount = KFormat.amountFormat.format(contract.amount);
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
              _detailText(tr('last_contract'), ' ${contract.lastContractId}'),
              _detailText(
                tr('number_of_contracts'),
                ' ${contract.contractCount}',
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
