// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/contract/domain/repos/contract_repo.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/ui/home/widgets/search_page.dart';
import 'package:fire_auth/ui/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../features/contract/domain/usecases/contract_usecases.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ContractRepository>();
    return BlocProvider(
      create: (_) => ContractBloc(
        createContract: CreateContract(repo),
        updateContract: UpdateContract(repo),
        deleteContract: DeleteContract(repo),
        getContracts: GetContracts(repo),
        repo: repo,
      )..add(LoadContracts()),
      child: const _HistoryPage(),
    );
  }
}

class _HistoryPage extends StatefulWidget {
  const _HistoryPage();

  @override
  State<_HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<_HistoryPage> {
  Filters currentFilter = Filters.empty;
  DateTime? fromDate;
  DateTime? toDate;

  final DateFormat formatter = KFormat.dateFormat;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts({bool nextPage = false}) {
    final bloc = context.read<ContractBloc>();
    bloc.add(
      LoadContracts(
        statuses: currentFilter.statuses.isNotEmpty
            ? currentFilter.statuses
            : null,
        fromDate: fromDate,
        toDate: toDate,
        startAfterDoc: nextPage ? bloc.state.lastDocSnap : null,
        limit: 10,
      ),
    );
  }

  void _onLoadMore() {
    _loadContracts(nextPage: true);
  }

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('from_to', context: context))),
          );
          return;
        }
        setState(() {
          fromDate = picked;
          currentFilter = currentFilter.copyWith(fromDate: picked);
        });
        _loadContracts();
      } else {
        if (fromDate != null && picked.isBefore(fromDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('to_from', context: context))),
          );
          return;
        }
        setState(() {
          toDate = picked;
          currentFilter = currentFilter.copyWith(toDate: picked);
        });
        _loadContracts();
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
          tr('history', context: context),
          style: Kstyle.textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
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

                if (result != null && result is Filters) {
                  setState(() {
                    currentFilter = result;
                    fromDate = result.fromDate;
                    toDate = result.toDate;
                  });
                  _loadContracts();
                }
              }
            },
          ),
          const SizedBox(width: 4.0),
          SvgPicture.asset('assets/svg/divider.svg'),
          const SizedBox(width: 4.0),
          IconButton(
            icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
            onPressed: () {
              final state = context.read<ContractBloc>().state;
              if (state.status == BlocStatus.loaded) {
                showSearchPageDialog(context, contracts: state.contracts);
              }
            },
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
              final contracts = state.contracts;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr('date', context: context), style: Kstyle.textStyle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.dark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fromDate != null
                                      ? formatter.format(fromDate!)
                                      : tr('from', context: context),
                                  style: Kstyle.textStyle,
                                ),
                                SvgPicture.asset('assets/svg/calendar.svg'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(height: 2, width: 10, color: AppColors.white),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 120,
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.dark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
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
                                    AppColors.iconBlur,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  tr('no_history', context: context),
                                  style: Kstyle.textStyle.copyWith(
                                    color: AppColors.iconBlur,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ContractsPage(
                            contracts: contracts,
                            onLoadMore: _onLoadMore,
                            canLoadMore: state.canLoadMore,
                            isLoadingMore: state.isLoadingMore,
                            openFromDetail: true,
                          ),
                  ),
                ],
              );
            }
            return Center(
              child: Text(tr('failed_to_load_contracts', context: context)),
            );
          },
        ),
      ),
    );
  }
}
