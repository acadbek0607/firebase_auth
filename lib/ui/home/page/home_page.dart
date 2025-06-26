import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/contract/presentation/pages/contract_page.dart';
import 'package:fire_auth/features/invoice/presentation/pages/invoive_page.dart';
import 'package:fire_auth/ui/home/widgets/calendar_widget.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:fire_auth/ui/home/widgets/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum HomeViewType { contract, invoice }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    selectedPageNotifier.value = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contracts'),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
          child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const ContractsPage(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const InvoicesPage(),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
