import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/invoice/domain/entities/invoice_entity.dart';
import 'package:fire_auth/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:fire_auth/features/invoice/presentation/widgets/invoice_card.dart';
import 'package:fire_auth/ui/new/pages/create_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDetailPage extends StatelessWidget {
  final InvoiceEntity invoice;
  final List<InvoiceEntity> allInvoices;

  const InvoiceDetailPage({
    super.key,
    required this.invoice,
    required this.allInvoices,
  });

  void _showDeleteDialog(BuildContext context, String invoiceId) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Why do you want to delete this invoice?'),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(hintText: 'Enter reason...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<TextEditingController>(
              valueListenable: ValueNotifier(reasonController),
              builder: (context, controller, _) {
                return ElevatedButton(
                  onPressed: controller.text.trim().isEmpty
                      ? null
                      : () {
                          context.read<InvoiceBloc>().add(
                            DeleteInvoiceEvent(invoiceId),
                          );
                          Navigator.pop(ctx);
                          Navigator.pop(context); // Close detail page
                        },
                  child: const Text('Delete'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final relatedInvoices = allInvoices
        .where((i) => i.serviceName == invoice.serviceName)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              children: [
                Card(
                  color: const Color(0xFF1E1E20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Service: ${invoice.serviceName}"),
                        Text("Status: ${invoice.status}"),
                        Text("Cost: ${invoice.cost}"),
                        Text("Created at: ${invoice.createdAt}"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            _showDeleteDialog(context, invoice.id ?? ''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withAlpha(77),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Delete Invoice',
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateInvoicePage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff008F7F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Create Invoice',
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Other invoices for "${invoice.serviceName}"',
              style: Kstyle.textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: relatedInvoices.length,
              itemBuilder: (context, index) {
                final item = relatedInvoices[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoiceDetailPage(
                          invoice: item,
                          allInvoices: allInvoices,
                        ),
                      ),
                    );
                  },
                  child: InvoiceCard(invoice: item, allInvoices: []),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
