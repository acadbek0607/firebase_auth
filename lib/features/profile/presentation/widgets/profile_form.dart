import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';

class ProfileForm extends StatefulWidget {
  final ProfileEntity profile;

  const ProfileForm({super.key, required this.profile});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController professionController;
  late final TextEditingController organizationController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.profile.fullName);
    phoneController = TextEditingController(text: widget.profile.phone);
    professionController = TextEditingController(
      text: widget.profile.profession,
    );
    organizationController = TextEditingController(
      text: widget.profile.organization,
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    professionController.dispose();
    organizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field('Full Name', fullNameController),
        _field('Phone Number', phoneController),
        _field('Profession', professionController),
        _field('Organization', organizationController),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final updated = widget.profile.copyWith(
              fullName: fullNameController.text,
              phone: phoneController.text,
              profession: professionController.text,
              organization: organizationController.text,
            );
            context.read<ProfileBloc>().add(SaveProfile(updated));
          },
          child: const Text('Save Profile'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignOutRequested());
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
