import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    selectedPageNotifier.value = 2;
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(204),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.tealAccent, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Что вы хотите создать?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _CreateButton(
                icon: Icons.description_outlined,
                text: 'Contract',
                onPressed: () {
                  Navigator.pushNamed(context, '/create_contract');
                },
              ),
              const SizedBox(height: 12),
              _CreateButton(
                icon: Icons.request_quote_outlined,
                text: 'Invoice',
                onPressed: () {
                  Navigator.pushNamed(context, '/create_invoice');
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: NavbarWidget(),
    );
  }
}

class _CreateButton extends StatelessWidget {
  final IconData icon;
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
      icon: Icon(icon, color: Colors.teal),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2B2B2B),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      onPressed: onPressed,
    );
  }
}
