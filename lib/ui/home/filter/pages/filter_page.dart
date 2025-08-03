// lib/ui/home/filter/pages/filter_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/core/utils/status.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/ui/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/ui/home/filter/widgets/custom_checkbox_tile.dart';

class FilterPage extends StatefulWidget {
  final Filters? initialFilter;
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
    final filter =
        widget.initialFilter ??
        activeFiltersNotifier.value[widget.originIndex] ??
        Filters.empty;
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

    final filter = Filters(
      statuses: selectedStatuses,
      fromDate: fromDate,
      toDate: toDate,
    );

    final filters = Map<int, Filters>.from(activeFiltersNotifier.value);
    if (filter == Filters.empty) {
      filters.remove(widget.originIndex);
    } else {
      filters[widget.originIndex] = filter;
    }
    activeFiltersNotifier.value = filters;

    Navigator.pop(context, filter);
    // return filtered contracts
  }

  void _cancelFilters() {
    final filters = Map<int, Filters>.from(activeFiltersNotifier.value);
    filters.remove(widget.originIndex);
    activeFiltersNotifier.value = filters;
    Navigator.pop(context, Filters.empty);
  }

  Future<void> _selectDate(bool isFrom) async {
    final now = DateTime.now();
    final initialDate = isFrom ? (fromDate ?? now) : (toDate ?? now);
    final firstDate = isFrom ? DateTime(2000) : (fromDate ?? DateTime(2000));
    final lastDate = isFrom ? (toDate ?? now) : now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      if (isFrom) {
        if (toDate != null && picked.isAfter(toDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('from_to', context: context))),
          );
          return;
        }
        setState(() => fromDate = picked);
      } else {
        if (fromDate != null && picked.isBefore(fromDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('to_from', context: context))),
          );
          return;
        }
        setState(() => toDate = picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.black,
        title: Text(
          tr('filters', context: context),
          style: Kstyle.textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28.0),
                Text(
                  tr('status', context: context),
                  style: Kstyle.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: AppColors.cardGrey,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Flexible(
                      child: CustomCheckboxTile(
                        label: tr('paid', context: context),
                        value: paid,
                        onChanged: (val) => setState(() => paid = val),
                      ),
                    ),
                    Flexible(
                      child: CustomCheckboxTile(
                        label: tr('rejected_iq', context: context),
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
                        label: tr('in_process', context: context),
                        value: inProcess,
                        onChanged: (val) => setState(() => inProcess = val),
                      ),
                    ),
                    Flexible(
                      child: CustomCheckboxTile(
                        label: tr('rejected_payme', context: context),
                        value: rejectedByPayme,
                        onChanged: (val) =>
                            setState(() => rejectedByPayme = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Text(
                  tr('date', context: context),
                  style: Kstyle.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: AppColors.cardGrey,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: InkWell(
                        onTap: () => _selectDate(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fromDate != null
                                    ? formatter.format(fromDate!)
                                    : tr('from', context: context),
                                style: const TextStyle(color: Colors.white),
                              ),
                              SvgPicture.asset('assets/svg/calendar.svg'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(width: 10.0, height: 2.0, color: AppColors.line),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 120.0,
                      child: InkWell(
                        onTap: () => _selectDate(false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.dark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                toDate != null
                                    ? formatter.format(toDate!)
                                    : tr('to', context: context),
                                style: Kstyle.textStyle,
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
                            AppColors.darkGreen.withAlpha(50),
                          ),
                        ),
                        child: Text(
                          tr('cancel', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGreen,
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
                          tr('apply', context: context),
                          style: Kstyle.textStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.line,
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
