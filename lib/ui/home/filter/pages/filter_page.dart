// lib/ui/home/filter/pages/filter_page.dart
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/ui/home/filter/widgets/custom_checkbox_tile.dart';

class FilterPage extends StatefulWidget {
  final FilterWidget? initialFilter;
  final int originIndex;
  final List<ContractEntity> contracts;

  const FilterPage({
    super.key,
    required this.contracts,
    this.initialFilter,
    this.originIndex = 0,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  late bool paid;
  late bool inProcess;
  late bool rejectedByIQ;
  late bool rejectedByPayme;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    final filter = widget.initialFilter ?? FilterWidget.empty;
    paid = filter.statuses.contains(StatusType.paid);
    inProcess = filter.statuses.contains(StatusType.inProcess);
    rejectedByIQ = filter.statuses.contains(StatusType.rejectedByIQ);
    rejectedByPayme = filter.statuses.contains(StatusType.rejectedByPayme);
    fromDate = filter.fromDate;
    toDate = filter.toDate;
    super.initState();
  }

  void _applyFilters() {
    final selectedStatuses = <StatusType>[];
    if (paid) selectedStatuses.add(StatusType.paid);
    if (inProcess) selectedStatuses.add(StatusType.inProcess);
    if (rejectedByIQ) selectedStatuses.add(StatusType.rejectedByIQ);
    if (rejectedByPayme) selectedStatuses.add(StatusType.rejectedByPayme);

    final filter = FilterWidget(
      statuses: selectedStatuses,
      fromDate: fromDate,
      toDate: toDate,
    );

    Navigator.pop(context, filter);
    // return filtered contracts
  }

  void _cancelFilters() {
    Navigator.pop(context, FilterWidget.empty);
  }

  Future<void> _selectDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      appBar: AppBar(title: const Text("Filters"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    Flexible(
                      child: CustomCheckboxTile(
                        label: "Paid",
                        value: paid,
                        onChanged: (val) => setState(() => paid = val),
                      ),
                    ),
                    Flexible(
                      child: CustomCheckboxTile(
                        label: "Rejected by IQ",
                        value: rejectedByIQ,
                        onChanged: (val) => setState(() => rejectedByIQ = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      child: CustomCheckboxTile(
                        label: "In Process",
                        value: inProcess,
                        onChanged: (val) => setState(() => inProcess = val),
                      ),
                    ),
                    Flexible(
                      child: CustomCheckboxTile(
                        label: "Rejected by Payme",
                        value: rejectedByPayme,
                        onChanged: (val) =>
                            setState(() => rejectedByPayme = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: InkWell(
                        onTap: () => _selectDate(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fromDate != null
                                    ? formatter.format(fromDate!)
                                    : "From",
                                style: const TextStyle(color: Colors.white),
                              ),
                              SvgPicture.asset('assets/svg/calendar.svg'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      width: 10.0,
                      height: 2.0,
                      color: Color(0xFFD1D1D1),
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 120.0,
                      child: InkWell(
                        onTap: () => _selectDate(false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                toDate != null
                                    ? formatter.format(toDate!)
                                    : "To",
                                style: const TextStyle(color: Colors.white),
                              ),
                              SvgPicture.asset('assets/svg/calendar.svg'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _cancelFilters,
                        style: Kstyle.buttonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xFF008F7F).withAlpha(50),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF008F7F),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: Kstyle.buttonStyle,
                        child: Text(
                          "Apply filters",
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDFDFD),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
