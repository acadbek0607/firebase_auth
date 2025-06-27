import 'package:fire_auth/ui/home/filter/pages/filter_page.dart';
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
  bool showSearch = false;
  DateTime? fromDate;
  DateTime? toDate;

  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 24.0),
                onPressed: () async {
                  // Get latest contracts from bloc state
                  final state = context.read<ContractBloc>().state;
                  if (state is ContractLoaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FilterPage(allContracts: state.contracts),
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 20.0),
                onPressed: () => setState(() {
                  showSearch = true;
                }),
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
            if (state is ContractLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ContractLoaded) {
              final filtered = _applyDateFilter(state.contracts);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
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
                                  ? formatter.format(fromDate!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward, color: Colors.white),
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
                              toDate != null
                                  ? formatter.format(toDate!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
