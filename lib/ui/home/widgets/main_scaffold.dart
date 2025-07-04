import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/profile/presentation/pages/profile_page.dart';
import 'package:fire_auth/ui/home/page/home_page.dart';
import 'package:fire_auth/ui/history/pages/history_page.dart';
import 'package:fire_auth/ui/new/pages/create_contract_page.dart';
import 'package:fire_auth/ui/new/pages/create_invoice_page.dart';
import 'package:fire_auth/ui/new/pages/new_page.dart';
import 'package:fire_auth/ui/saved/pages/saved_page.dart';

class MainScaffold extends StatefulWidget {
  final Widget? child;

  const MainScaffold({super.key, this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<Widget> _pages = const [
    HomePage(), // 0
    HistoryPage(), // 1
    NewPage(), // 2
    SavedPage(), // 3
    ProfilePage(), // 4
    CreateContractPage(), // 5 (subpage of New)
    CreateInvoicePage(), // 6 (subpage of New)
  ];

  static const List<String> _labels = [
    "Contracts",
    "History",
    "New",
    "Saved",
    "Profile",
  ];

  static const List<String> _icons = [
    'contracts',
    'history',
    'new',
    'saved',
    'profile',
  ];

  int _selectedIndex = selectedPageNotifier.value;

  void _onTabTapped(int index) {
    // If user is in create_contract/create_invoice and taps "New" again, go back to NewPage (index 2)
    if (_selectedIndex > 4 && index == 2) {
      selectedPageNotifier.value = 2;
    } else {
      selectedPageNotifier.value = index;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedPageNotifier.addListener(() {
      if (mounted) {
        setState(() => _selectedIndex = selectedPageNotifier.value);
      }
    });
  }

  @override
  void dispose() {
    selectedPageNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          widget.child ?? IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex > 4
            ? 2
            : _selectedIndex, // highlight "New"
        onDestinationSelected: _onTabTapped,
        indicatorColor: Colors.transparent,
        destinations: List.generate(5, (i) {
          final isSelected = (_selectedIndex > 4 ? 2 : _selectedIndex) == i;
          return NavigationDestination(
            icon: SvgPicture.asset(
              'assets/svg/${isSelected ? 's_' : ''}${_icons[i]}.svg',
            ),
            label: _labels[i],
          );
        }),
      ),
    );
  }
}
