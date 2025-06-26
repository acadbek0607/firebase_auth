import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final List<InvoiceEntity> allInvoices;
  final VoidCallback? onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.allInvoices,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                Text(
                  '№ ${invoice.id ?? '—'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                    invoice.status.label,
                    style: TextStyle(color: invoice.status.color, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Service: ${invoice.serviceName}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount: \$${invoice.cost.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  '${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}',
                  style: const TextStyle(color: Color(0xFF999999)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
