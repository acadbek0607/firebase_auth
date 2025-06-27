import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/presentation/bloc/contract_bloc.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/invoice/presentation/pages/invoive_page.dart';
import 'package:fire_auth/ui/home/filter/pages/filter_page.dart';
import 'package:fire_auth/ui/home/widgets/calendar_widget.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:fire_auth/ui/home/widgets/search_widget.dart';
import 'package:fire_auth/ui/home/widgets/toggle_button_widget.dart';
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
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    selectedPageNotifier.value = 0;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Contracts'),
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
              child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/search.svg',
                      height: 20.0,
                    ),
                    onPressed: () => setState(() {
                      showSearch = true;
                    }),
                  ),
                  SizedBox(width: 4.0),
                  SvgPicture.asset('assets/svg/divider.svg'),
                  SizedBox(width: 4.0),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/filter.svg',
                      height: 24.0,
                    ),
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
                  SizedBox(width: 16.0),
                ],
              ),
            ],
          ),
          body: ValueListenableBuilder<HomeViewType>(
            valueListenable: selectedViewNotifier,
            builder: (context, viewType, _) {
              return Column(
                children: [
                  const CalendarWidget(),
                  const SizedBox(height: 32),
                  const ToggleButtonsWidget(),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: viewType == HomeViewType.contract
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: const ContractsPage(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: const InvoicesPage(),
                          ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: NavbarWidget(),
        ),

        if (showSearch)
          SearchWidget(onClose: () => setState(() => showSearch = false)),
      ],
    );
  }
}
