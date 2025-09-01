import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileForm extends StatefulWidget {
  final VoidCallback onDismiss;
  final bool showBack;
  const EditProfileForm({
    super.key,
    required this.onDismiss,
    this.showBack = true,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _organizationController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _fullNameController.text = profile.fullName ?? '';
      _dobController.text = profile.dateOfBirth ?? '';
      _phoneController.text = profile.phone ?? '';
      _professionController.text = profile.profession ?? '';
      _organizationController.text = profile.organization ?? '';
      _emailController.text = profile.email;
    } else {
      final user = context.read<AuthBloc>().state.user;
      _emailController.text = user?.email ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _organizationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final authState = context.read<AuthBloc>().state;
    final uid = authState.user?.uid;
    if (uid == null) return;
    final currentProfile = context.read<ProfileBloc>().state.profile;
    final profile = ProfileEntity(
      uid: uid,
      fullName: _fullNameController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      phone: _phoneController.text.trim(),
      profession: _professionController.text.trim(),
      organization: _organizationController.text.trim(),
      email: _emailController.text.trim(),
      savedContractIds: currentProfile?.savedContractIds ?? [],
    );
    context.read<ProfileBloc>().add(SaveProfile(profile));
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkest,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.showBack
                        ? IconButton(
                            onPressed: widget.onDismiss,
                            icon: const Icon(Icons.arrow_back),
                          )
                        : const SizedBox(width: 48),
                    Text(
                      tr('profile', context: context),
                      style: Kstyle.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('full_name', context: context),
                  ),
                  style: Kstyle.textStyle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _professionController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('profession', context: context),
                  ),
                  style: Kstyle.textStyle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _organizationController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('organization', context: context),
                  ),
                  style: Kstyle.textStyle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dobController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('date_of_birth', context: context),
                  ),
                  style: Kstyle.textStyle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('phone', context: context),
                  ),
                  style: Kstyle.textStyle,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('email', context: context),
                  ),
                  style: Kstyle.textStyle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _onSave,
                  style: Kstyle.buttonStyle.copyWith(
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 48),
                    ),
                  ),
                  child: Text(
                    tr('save', context: context),
                    style: Kstyle.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
