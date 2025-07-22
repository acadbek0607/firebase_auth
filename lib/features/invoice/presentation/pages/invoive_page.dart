import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/presentation/widgets/invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvoicesPage extends StatelessWidget {
  final List<InvoiceEntity> invoices;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const InvoicesPage({
    super.key,
    required this.invoices,
    this.canLoadMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore && invoices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/contracts.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF323232),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              tr('no_invoices', context: context),
              style: Kstyle.textStyle.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323232),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: invoices.length + (canLoadMore || isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < invoices.length) {
          final invoice = invoices[index];
          return InvoiceCard(invoice: invoice, allInvoices: invoices);
        } else {
          if (isLoadingMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  tr('loading', context: context),
                  style: Kstyle.textStyle.copyWith(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00A795),
                  ),
                ),
              ),
            );
          }
          if (!canLoadMore) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                style: Kstyle.buttonStyle,
                child: Text(
                  tr('load_more', context: context),
                  style: Kstyle.textStyle,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
