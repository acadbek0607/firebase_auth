import 'package:fire_auth/core/constants/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  static const List<String> title = [
    "Contracts",
    "History",
    "New",
    "Saved",
    "Profile",
  ];

  static const List<String> routes = [
    '/home',
    '/history',
    '/new',
    '/saved',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, _) {
        return NavigationBar(
          indicatorColor: Colors.transparent,
          destinations: List.generate(5, (index) {
            final isSelected = selectedPage == index;
            final iconName = [
              'contracts',
              'history',
              'new',
              'saved',
              'profile',
            ][index];

            return NavigationDestination(
              icon: SvgPicture.asset(
                'assets/svg/${isSelected ? 's_' : ''}$iconName.svg',
              ),
              label: title[index],
            );
          }),
          onDestinationSelected: (int index) {
            selectedPageNotifier.value = index;
            final route = routes[index];
            if (ModalRoute.of(context)?.settings.name != route) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
