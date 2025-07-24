import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // selectedPageNotifier.value = 2;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2D),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr('what_create', context: context),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _CreateButton(
                icon: 'assets/svg/contract.svg',
                text: tr('contract', context: context),
                onPressed: () {
                  Navigator.of(context).pop();
                  selectedPageNotifier.value = 5;
                },
              ),
              const SizedBox(height: 12),
              _CreateButton(
                icon: 'assets/svg/invoice.svg',
                text: tr('invoice', context: context),
                onPressed: () {
                  Navigator.of(context).pop();
                  selectedPageNotifier.value = 6;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Future<Object?>> showNewPageDialog(BuildContext context) async {
  final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight;
  return showGeneralDialog(
    barrierColor: Colors.transparent.withAlpha(210),
    context: context,
    barrierDismissible: true,
    barrierLabel: 'NewPageDialog',
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              bottom: 0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.7, sigmaY: 1.7),
                child: Container(color: Colors.transparent),
              ),
            ),
            const Center(child: NewPage()),
          ],
        ),
      );
    },
  );
}

class _CreateButton extends StatelessWidget {
  final String icon; // svg path
  final String text;
  final VoidCallback onPressed;

  const _CreateButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(icon, width: 26.0, height: 26.0),
      label: Text(
        text,
        style: Kstyle.textStyle.copyWith(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4E4E4E).withAlpha(102),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 0,
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
    );
  }
}
