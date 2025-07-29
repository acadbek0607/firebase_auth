import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final List<InvoiceEntity> allInvoices;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.allInvoices,
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = KFormat.amountFormat.format(invoice.cost);
    final formattedDate = KFormat.dateFormat.format(invoice.createdAt);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
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
                  SvgPicture.asset('assets/svg/invoice.svg', height: 18.0),
                  SizedBox(width: 8.0),
                  Text(
                    '№ ${invoice.id ?? '—'}',
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
                  color: invoice.status.color.withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invoice.status.label(context),
                  style: Kstyle.textStyle.copyWith(
                    color: invoice.status.color,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: '${tr('service', context: context)} ',
              style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: invoice.serviceName,
                  style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
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
                  text: '${tr('amount', context: context)} ',
                  style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text:
                          '$formattedAmount ${tr('currency', context: context)}',
                      style: Kstyle.textStyle.copyWith(
                        color: AppColors.cardGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formattedDate,
                style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
