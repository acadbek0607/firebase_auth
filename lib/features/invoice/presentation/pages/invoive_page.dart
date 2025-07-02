import 'package:fire_auth/core/constants/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:fire_auth/features/invoice/presentation/widgets/invoice_card.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:flutter_svg/svg.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state.status == InvoiceStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == InvoiceStatus.loaded) {
          final List<InvoiceEntity> invoices = state.invoices;

          if (invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/contracts.svg',
                    colorFilter: ColorFilter.mode(
                      Color(0xFF323232),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "No invoices available",
                    style: Kstyle.textStyle.copyWith(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF323232),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<InvoiceBloc>().add(LoadInvoices());
            },
            child: ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return InvoiceCard(invoice: invoice, allInvoices: []);
              },
            ),
          );
        } else if (state.status == InvoiceStatus.error) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
