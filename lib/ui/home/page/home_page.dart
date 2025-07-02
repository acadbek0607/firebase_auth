import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/domain/entities/contract_entity.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/invoice/presentation/pages/invoive_page.dart';
import 'package:fire_auth/ui/home/widgets/calendar_widget.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:fire_auth/ui/home/widgets/toggle_button_widget.dart';
import 'package:fire_auth/ui/widgets/filter_widget.dart';
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
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier(
    DateTime.now(),
  );
  List<ContractEntity>? _filteredContracts;
  FilterWidget _currentFilter = FilterWidget.empty;

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
                onPressed: () async {
                  final state = context.read<ContractBloc>().state;
                  if (state.status == BlocStatus.loaded) {
                    final result = await Navigator.pushNamed(
                      context,
                      '/filter',
                      arguments: {
                        'currentFilter': _currentFilter,
                        'originIndex': 0, // 0 = Home, 1 = History, 3 = Saved
                      },
                    );

                    if (result is FilterWidget) {
                      setState(() {
                        _currentFilter = result;
                        _filteredContracts = _currentFilter.apply(
                          state.contracts,
                        );
                      });
                    }
                  }
                },
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
                initialDate: selectedDateNotifier.value,
                onDaySelected: (day) {
                  selectedDateNotifier.value = day;
                },
              ),
              const SizedBox(height: 32),
              const ToggleButtonsWidget(),
              const SizedBox(height: 20.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: viewType == HomeViewType.contract
                      ? ContractsPage(filteredContracts: _filteredContracts)
                      : const InvoicesPage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
