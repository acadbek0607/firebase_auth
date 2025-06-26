import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
import 'package:flutter/material.dart';

class ToggleButtonsWidget extends StatefulWidget {
  const ToggleButtonsWidget({super.key});

  @override
  State<ToggleButtonsWidget> createState() => _ToggleButtonsWidgetState();
}

class _ToggleButtonsWidgetState extends State<ToggleButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HomeViewType>(
      valueListenable: selectedViewNotifier,
      builder: (context, viewType, _) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  selectedViewNotifier.value = HomeViewType.contract;
                },
                style: Kstyle.buttonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    viewType == HomeViewType.contract
                        ? const Color(0xFF00A795)
                        : const Color(0xFF00A795).withAlpha(0),
                  ),
                ),
                child: const Text(
                  'Contracts',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  selectedViewNotifier.value = HomeViewType.invoice;
                },
                style: Kstyle.buttonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    viewType != HomeViewType.contract
                        ? const Color(0xFF008F7F)
                        : Colors.transparent,
                  ),
                ),
                child: const Text(
                  'Invoices',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
