import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
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
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final List<Widget> _pages = [
    const HomePage(), // 0
    HistoryPage(), // 1
    const SizedBox.shrink(), // 2
    const SavedPage(), // 3
    const ProfilePage(), // 4
    const CreateContractPage(), // 5 (subpage of New)
    const CreateInvoicePage(), // 6 (subpage of New)
    // 7 - Filter page
    ValueListenableBuilder<Widget?>(
      valueListenable: filterPageNotifier,
      builder: (_, page, __) => page ?? const SizedBox.shrink(),
    ),
    // 8 - Contract detail page
    ValueListenableBuilder<Widget?>(
      valueListenable: detailPageNotifier,
      builder: (_, page, __) => page ?? const SizedBox.shrink(),
    ),
  ];

  List<String> _labels() => [
    tr('contracts', context: context),
    tr('history', context: context),
    tr('new', context: context),
    tr('saved', context: context),
    tr('profile', context: context),
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
    // If the filter page is open, close it before navigating away.
    if (_selectedIndex == 7) {
      filterPageNotifier.value = null;
      Navigator.of(context).pop();
    }

    // If user taps "New" again, show the dialog
    if (index == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showNewPageDialog(context);
      });
      return;
    }
    selectedPageNotifier.value = index;
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
    final labels = _labels();
    // Determine which icon should be active in the navigation bar
    int navIndex = _selectedIndex;
    if (_selectedIndex == 7) {
      navIndex = filterOriginIndexNotifier.value;
    } else if (_selectedIndex == 8) {
      navIndex = detailOriginIndexNotifier.value;
    } else if (_selectedIndex > 4) {
      navIndex = 2; // highlight "New" for create pages
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navIndex,
        onDestinationSelected: _onTabTapped,
        indicatorColor: AppColors.darkest,
        indicatorShape: const CircleBorder(
          eccentricity: BorderSide.strokeAlignCenter,
        ),
        overlayColor: WidgetStateProperty.all(AppColors.darkest.withAlpha(11)),

        backgroundColor: AppColors.darkest,
        destinations: List.generate(5, (i) {
          final isSelected = navIndex == i;
          return NavigationDestination(
            icon: SvgPicture.asset(
              'assets/svg/${isSelected ? 's_' : ''}${_icons[i]}.svg',
            ),
            label: labels[i],
          );
        }),
      ),
    );
  }
}
