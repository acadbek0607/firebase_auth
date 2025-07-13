import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/invoice/presentation/pages/invoive_page.dart';
import 'package:fire_auth/ui/home/filter/pages/filter_page.dart';
import 'package:fire_auth/ui/home/widgets/calendar_widget.dart';
import 'package:fire_auth/ui/home/widgets/toggle_button_widget.dart';
import 'package:fire_auth/ui/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

enum HomeViewType { contract, invoice }

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDay = DateTime.now();
  DocumentSnapshot? _lastDocSnap;
  Filters _currentFilter = Filters.empty;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts({bool nextPage = false}) {
    final bloc = context.read<ContractBloc>();
    bloc.add(
      LoadContracts(
        day: _selectedDay,
        statuses: _currentFilter.statuses.isNotEmpty
            ? _currentFilter.statuses
            : null,
        fromDate: _selectedDay == null ? _currentFilter.fromDate : null,
        toDate: _selectedDay == null ? _currentFilter.toDate : null,
        startAfterDoc: nextPage ? _lastDocSnap : null,
        limit: 10,
      ),
    );
  }

  void _onCalendarDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
      _currentFilter = Filters.empty;
    });
    _loadContracts();
  }

  void _onFilterApplied(Filters filter) {
    setState(() {
      _currentFilter = filter;
      if (_currentFilter.fromDate != _selectedDay ||
          _currentFilter.toDate != _selectedDay) {
        _selectedDay = null;
      }
    });
    _loadContracts();
  }

  void _onLoadMore() {
    _loadContracts(nextPage: true);
  }

  Future<void> openReusableFilterPage({
    required BuildContext context,
    required Filters currentFilter,
    required void Function(Filters) onFilterApplied,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FilterPage(contracts: [], initialFilter: currentFilter),
      ),
    );
    // If cancel or empty, always reset to Filters.empty
    if (result == null || (result is Filters && result == Filters.empty)) {
      onFilterApplied(Filters.empty);
      return;
    }
    if (result is Filters) {
      onFilterApplied(result);
    }
  }

  Future<void> _openFilterPage() async {
    await openReusableFilterPage(
      context: context,
      currentFilter: _currentFilter,
      onFilterApplied: _onFilterApplied,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contracts'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
                onPressed: () => Navigator.pushNamed(context, '/search'),
              ),
              const SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              const SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 16.0),
                onPressed: _openFilterPage,
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<HomeViewType>(
        valueListenable: selectedViewNotifier,
        builder: (context, viewType, _) {
          return Column(
            children: [
              CalendarWidget(
                initialDate: _selectedDay,
                onDaySelected: _onCalendarDaySelected,
              ),
              const SizedBox(height: 32),
              const ToggleButtonsWidget(),
              const SizedBox(height: 20.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: viewType == HomeViewType.contract
                      ? BlocBuilder<ContractBloc, ContractState>(
                          builder: (context, state) {
                            return ContractsPage(
                              contracts: state.contracts,
                              canLoadMore: state.canLoadMore,
                              isLoadingMore: state.isLoadingMore,
                              onLoadMore: _onLoadMore,
                            );
                          },
                        )
                      : InvoicesPage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
