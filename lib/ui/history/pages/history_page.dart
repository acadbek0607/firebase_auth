import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/filter_utils.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/widgets/contract_card.dart';
import 'package:fire_auth/ui/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FilterWidget currentFilter = FilterWidget.empty;
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
      lastDate: now,
    );

    if (picked != null) {
      if (isFrom) {
        if (toDate != null && picked.isAfter(toDate!)) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("From date must be before To date")),
          );
          return;
        }
        setState(() => fromDate = picked);
      } else {
        if (fromDate != null && picked.isBefore(fromDate!)) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("To date must be after From date")),
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
      appBar: AppBar(
        title: const Text('History'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/svg/filter.svg', height: 16.0),
            onPressed: () async {
              final state = context.read<ContractBloc>().state;
              if (state.status == BlocStatus.loaded) {
                final result = await Navigator.pushNamed(
                  context,
                  '/filter',
                  arguments: {
                    'allContracts': state.contracts,
                    'currentFilter': currentFilter,
                    'originIndex': 1,
                  },
                );

                if (result != null && result is FilterWidget) {
                  setState(() {
                    currentFilter = result;
                    fromDate = result.fromDate;
                    toDate = result.toDate;
                  });
                }
              }
            },
          ),
          const SizedBox(width: 4.0),
          SvgPicture.asset('assets/svg/divider.svg'),
          const SizedBox(width: 4.0),
          IconButton(
            icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          const SizedBox(width: 16.0),
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
              final contracts = FilterUtils.apply(
                state.contracts,
                currentFilter,
              );

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
                              color: Colors.grey[850],
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
                              color: Colors.grey[850],
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
                    child: contracts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/contracts.svg',
                                  height: 88,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF323232),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'No history for this period',
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
                            itemCount: contracts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) => ContractCard(
                              contract: contracts[index],
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
