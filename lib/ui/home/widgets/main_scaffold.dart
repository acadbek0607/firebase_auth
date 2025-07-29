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
  final Widget? child;

  const MainScaffold({super.key, this.child});

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
    // If user is in create_contract/create_invoice and taps "New" again, go back to NewPage (index 2)
    if (index == 2) {
      if (_selectedIndex != 0) {
        selectedPageNotifier.value = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) showNewPageDialog(context);
        });
      } else {
        showNewPageDialog(context);
      }
      return;
    }
    if (widget.child != null) {
      selectedPageNotifier.value = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/history');
          break;
        case 2:
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/saved');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/home');
      }
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
    final labels = _labels();
    return Scaffold(
      body:
          widget.child ?? IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex > 4
            ? 2
            : _selectedIndex, // highlight "New"
        onDestinationSelected: _onTabTapped,
        indicatorColor: AppColors.darkest,
        indicatorShape: CircleBorder(
          eccentricity: BorderSide.strokeAlignCenter,
        ),
        overlayColor: WidgetStateProperty.all(AppColors.darkest.withAlpha(11)),

        backgroundColor: AppColors.darkest,
        destinations: List.generate(5, (i) {
          final isSelected = (_selectedIndex > 4 ? 2 : _selectedIndex) == i;
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
