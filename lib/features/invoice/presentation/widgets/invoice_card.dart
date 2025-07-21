import 'package:easy_localization/easy_localization.dart';
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
    final formattedAmount = KDataFormat.amountFormat.format(invoice.cost);
    final formattedDate = KDataFormat.dateFormat.format(invoice.createdAt);
    return Container(
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
                  SvgPicture.asset('assets/svg/invoice.svg'),
                  SizedBox(width: 8.0),
                  Text(
                    '№ ${invoice.id ?? '—'}',
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
                  color: invoice.status.color.withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invoice.status.label(context),
                  style: TextStyle(color: invoice.status.color, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${tr('service', context: context)} ${invoice.serviceName}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '''${tr('amount', context: context)} $formattedAmount so'm''',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Color(0xFF999999)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
