import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class FilterPage extends StatefulWidget {
  final List<ContractEntity> allContracts;

  const FilterPage({super.key, required this.allContracts});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final DateFormat dateFormat = KDataFormat.dateFormat;

  bool paid = false;
  bool inProcess = false;
  bool rejectedByIQ = false;
  bool rejectedByPayme = false;

  DateTime? fromDate;
  DateTime? toDate;

  List<ContractEntity> filteredContracts = [];

  void _applyFilters() {
    final selectedStatuses = <String>[];
    if (paid) selectedStatuses.add("paid");
    if (inProcess) selectedStatuses.add("inProcess");
    if (rejectedByIQ) selectedStatuses.add("rejectedByIQ");
    if (rejectedByPayme) selectedStatuses.add("rejectedByPayme");

    final DateTime? startDate = fromDate != null
        ? DateTime(fromDate!.year, fromDate!.month, fromDate!.day, 0, 0, 0)
        : null;
    final DateTime? endDate = toDate != null
        ? DateTime(toDate!.year, toDate!.month, toDate!.day, 23, 59, 59)
        : null;

    final result = widget.allContracts.where((contract) {
      final statusMatch =
          selectedStatuses.isEmpty ||
          selectedStatuses.contains(contract.status.name);

      final created = contract.createdAt;

      final dateMatch =
          (startDate == null || !created.isBefore(startDate)) &&
          (endDate == null || !created.isAfter(endDate));

      return statusMatch && dateMatch;
    }).toList();

    setState(() {
      filteredContracts = result;
    });
  }

  void _cancelFilters() {
    setState(() {
      paid = false;
      inProcess = false;
      rejectedByIQ = false;
      rejectedByPayme = false;
      fromDate = null;
      toDate = null;
      filteredContracts = [];
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filter Contracts"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // ✅ STATUS ROWS
            Row(
              children: [
                Flexible(
                  child: CheckboxListTile(
                    value: paid,
                    onChanged: (val) => setState(() => paid = val!),
                    title: const Text('Paid'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Flexible(
                  child: CheckboxListTile(
                    value: rejectedByIQ,
                    onChanged: (val) => setState(() => rejectedByIQ = val!),
                    title: const Text('Rejected by IQ'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: CheckboxListTile(
                    value: inProcess,
                    onChanged: (val) => setState(() => inProcess = val!),
                    title: const Text('In Process'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Flexible(
                  child: CheckboxListTile(
                    value: rejectedByPayme,
                    onChanged: (val) => setState(() => rejectedByPayme = val!),
                    title: const Text('Rejected by Payme'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // ✅ DATE PICKERS
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      child: Text(
                        fromDate != null
                            ? dateFormat.format(fromDate!)
                            : 'Select',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      child: Text(
                        toDate != null ? dateFormat.format(toDate!) : 'Select',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ FILTER ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelFilters,
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ SCROLLABLE CONTRACT LIST
            if (filteredContracts.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: filteredContracts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return ContractCard(
                      contract: filteredContracts[index],
                      allContracts: widget.allContracts,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
