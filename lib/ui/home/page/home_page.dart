import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:fire_auth/features/invoice/presentation/pages/invoive_page.dart';
import 'package:fire_auth/ui/detail/widgets/responsive_center.dart';
import 'package:fire_auth/ui/home/widgets/calendar_widget.dart';
import 'package:fire_auth/ui/home/widgets/search_page.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateTime? _selectedDay = DateTime.now();
  Filters _currentFilter = Filters.empty;

  @override
  void initState() {
    super.initState();
    _currentFilter = activeFiltersNotifier.value[0] ?? Filters.empty;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedViewNotifier.value == HomeViewType.contract ? 0 : 1,
    );
    _tabController.addListener(_handleTabSelection);
    _loadContracts();
    selectedViewNotifier.addListener(_onViewTypeChanged);
    selectedPageNotifier.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    selectedViewNotifier.removeListener(_onViewTypeChanged);
    selectedPageNotifier.addListener(_onPageChanged);
    super.dispose();
  }

  void _onViewTypeChanged() {
    final index = selectedViewNotifier.value == HomeViewType.contract ? 0 : 1;
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
    if (selectedViewNotifier.value == HomeViewType.contract) {
      _loadContracts();
    } else {
      _loadInvoices();
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    final newType = _tabController.index == 0
        ? HomeViewType.contract
        : HomeViewType.invoice;
    if (selectedViewNotifier.value != newType) {
      selectedViewNotifier.value = newType;
    }
  }

  void _onPageChanged() {
    if (selectedPageNotifier.value != 0) return;
    final filter = activeFiltersNotifier.value[0] ?? Filters.empty;
    setState(() {
      _currentFilter = filter;
      if (filter == Filters.empty) {
        _selectedDay = DateTime.now();
      } else if (filter.fromDate != null || filter.toDate != null) {
        _selectedDay = null;
      }
    });
    _loadContracts();
    _loadInvoices();
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
        startAfterDoc: nextPage ? bloc.state.lastDocSnap : null,
        limit: 10,
      ),
    );
  }

  void _loadInvoices({bool nextPage = false}) {
    final bloc = context.read<InvoiceBloc>();
    bloc.add(
      LoadInvoices(
        day: _selectedDay,
        statuses: _currentFilter.statuses.isNotEmpty
            ? _currentFilter.statuses
            : null,
        fromDate: _selectedDay == null ? _currentFilter.fromDate : null,
        toDate: _selectedDay == null ? _currentFilter.toDate : null,
        startAfterDoc: nextPage ? bloc.state.lastDocSnap : null,
        limit: 10,
      ),
    );
  }

  void _onCalendarDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
      _currentFilter = Filters.empty;
    });
    final filters = Map<int, Filters>.from(activeFiltersNotifier.value);
    filters.remove(0);
    activeFiltersNotifier.value = filters;
    _loadContracts();
    _loadInvoices();
  }

  void _onFilterApplied(Filters filter) {
    setState(() {
      _currentFilter = filter;
      if (filter == Filters.empty) {
        _selectedDay = DateTime.now();
      } else if ((_currentFilter.fromDate != null ||
              _currentFilter.toDate != null) ||
          (_currentFilter.fromDate != null && _currentFilter.toDate != null)) {
        _selectedDay = null;
      }
    });
    final filters = Map<int, Filters>.from(activeFiltersNotifier.value);
    if (filter == Filters.empty) {
      filters.remove(0);
    } else {
      filters[0] = filter;
    }
    activeFiltersNotifier.value = filters;

    _loadContracts();

    _loadInvoices();
  }

  void _onLoadMore() {
    if (selectedViewNotifier.value == HomeViewType.contract) {
      _loadContracts(nextPage: true);
    } else {
      _loadInvoices(nextPage: true);
    }
  }

  Future<void> openReusableFilterPage({
    required BuildContext context,
    required Filters currentFilter,
    required void Function(Filters) onFilterApplied,
  }) async {
    final result = await Navigator.pushNamed(
      context,
      '/filter',
      arguments: {
        'allContracts': <ContractEntity>[],
        'currentFilter': currentFilter,
        'originIndex': 0,
      },
    );
    // If cancel or empty, always reset to Filters.empty
    if (result is Filters) {
      if (result == Filters.empty) {
        onFilterApplied(Filters.empty);
      } else {
        onFilterApplied(result);
      }
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
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.black,
        title: Text(
          tr('contracts', context: context),
          style: Kstyle.textStyle.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/svg/filter.svg', height: 16.0),
                onPressed: _openFilterPage,
              ),
              const SizedBox(width: 4.0),
              SvgPicture.asset('assets/svg/divider.svg'),
              const SizedBox(width: 4.0),
              IconButton(
                icon: SvgPicture.asset('assets/svg/search.svg', height: 16.0),
                onPressed: () => showSearchPageDialog(context),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          CalendarWidget(
            initialDate: _selectedDay,
            onDaySelected: _onCalendarDaySelected,
          ),
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const ToggleButtonsWidget(),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
              body: ResponsiveCenter(
                child: Container(
                  color: AppColors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<ContractBloc, ContractState>(
                        builder: (context, state) {
                          return ContractsPage(
                            contracts: state.contracts,
                            canLoadMore: state.canLoadMore,
                            isLoadingMore: state.isLoadingMore,
                            onLoadMore: _onLoadMore,
                            originIndex: 0,
                          );
                        },
                      ),
                      BlocBuilder<InvoiceBloc, InvoiceState>(
                        builder: (context, state) {
                          return InvoicesPage(
                            invoices: state.invoices,
                            canLoadMore: state.canLoadMore,
                            isLoadingMore: state.isLoadingMore,
                            onLoadMore: _onLoadMore,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
