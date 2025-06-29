import 'package:flutter/material.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E20),
      child: ListTile(
        title: Text(profile.email, style: const TextStyle(color: Colors.white)),
        subtitle: const Text(
          'Email (read-only)',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
