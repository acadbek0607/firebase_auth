import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // selectedPageNotifier.value = 2;
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Что вы хотите создать?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _CreateButton(
                icon: 'assets/svg/contract.svg',
                text: 'Contract',
                onPressed: () {
                  selectedPageNotifier.value = 5;
                },
              ),
              const SizedBox(height: 12),
              _CreateButton(
                icon: 'assets/svg/invoice.svg',
                text: 'Invoice',
                onPressed: () {
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
        backgroundColor: const Color(0xFF4E4E4E),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
    );
  }
}
