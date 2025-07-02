import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? fromDate;
  DateTime? toDate;

  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final initialDate = isFrom ? (fromDate ?? now) : (toDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now, // Prevent picking a future date
    );

    if (picked != null) {
      if (isFrom) {
        if (toDate != null && picked.isAfter(toDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("From date must be before To date")),
          );
          return;
        }
        setState(() => fromDate = picked);
      } else {
        if (fromDate != null && picked.isBefore(fromDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("To date must be after From date")),
          );
          return;
        }
        setState(() => toDate = picked);
      }
    }
  }

  List<ContractEntity> _applyDateFilter(List<ContractEntity> contracts) {
    return contracts.where((contract) {
      final created = contract.createdAt;
      final matchFrom = fromDate == null || !created.isBefore(fromDate!);
      final matchTo = toDate == null || !created.isAfter(toDate!);
      return matchFrom && matchTo;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 16.0),
                onPressed: () async {
                  // Get latest contracts from bloc state
                  final state = context.read<ContractBloc>().state;
                  if (state.status == BlocStatus.loaded) {
                    Navigator.pushNamed(
                      context,
                      '/filter',
                      arguments: {'allContracts': state.contracts},
                    );
                  }
                },
              ),
              SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
                onPressed: () => Navigator.pushNamed(context, '/search'),
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ContractBloc, ContractState>(
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == BlocStatus.loaded) {
              final filtered = _applyDateFilter(state.contracts);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850], // Your background color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fromDate != null
                                      ? formatter.format(fromDate!)
                                      : 'From',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 4.0),
                                SvgPicture.asset('assets/svg/calendar.svg'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(height: 2, width: 10, color: Colors.white),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850], // Your background color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  toDate != null
                                      ? formatter.format(toDate!)
                                      : 'To',
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
                  const SizedBox(height: 16),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/contracts.svg',
                                  height: 88,
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFF323232),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'No history for this  period',
                                  style: Kstyle.textStyle.copyWith(
                                    color: Color(0xFF323232),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) => ContractCard(
                              contract: filtered[index],
                              allContracts: state.contracts,
                            ),
                          ),
                  ),
                ],
              );
            }
            return const Center(child: Text("Failed to load contracts"));
          },
        ),
      ),
    );
  }
}
