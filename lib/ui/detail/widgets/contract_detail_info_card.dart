// contract_detail_info_card.dart
import 'package:fire_auth/core/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';

class ContractDetailInfoCard extends StatelessWidget {
  final ContractEntity contract;

  const ContractDetailInfoCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF1E1E20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailText('Fisher’s full name', contract.fullName),
              _detailText('Status', contract.status.label),
              _detailText('Amount', '${contract.amount}'),
              _detailText('Address', contract.organizationAddress),
              _detailText('ITN/IEC', contract.inn),
              _detailText(
                'Created at',
                '${contract.createdAt.day}/${contract.createdAt.month}/${contract.createdAt.year}',
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
              text: '$title: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF999999),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
