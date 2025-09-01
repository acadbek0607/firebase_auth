import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/utils/uz_phone_input_fomatter.dart';
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
      _phoneController.text = profile.phone?.isNotEmpty == true
          ? profile.phone!
          : '';
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
                const SizedBox(width: 48),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  controller: _fullNameController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('full_name', context: context),
                  ),
                  style: Kstyle.textStyle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  controller: _professionController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('profession', context: context),
                  ),
                  style: Kstyle.textStyle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Profession is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  controller: _organizationController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('organization', context: context),
                  ),
                  style: Kstyle.textStyle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Organization is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _dobController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('date_of_birth', context: context),
                  ),
                  style: Kstyle.textStyle,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Date of birth is required';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    final initialDate = _dobController.text.isNotEmpty
                        ? DateFormat('dd.MM.yyyy').parse(_dobController.text)
                        : DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _dobController.text = DateFormat(
                        'dd.MM.yyyy',
                      ).format(picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('phone', context: context),
                  ),
                  style: Kstyle.textStyle,
                  inputFormatters: [UzPhoneInputFormatter()],
                  validator: (value) {
                    if (value == null) return 'Phone is required';
                    final digits = value.replaceAll(RegExp(r'\D'), '');
                    if (digits.length != 12) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('email', context: context),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        width: 1.2,
                        color: AppColors.cardGrey,
                      ),
                    ),
                  ),
                  style: Kstyle.textStyle.copyWith(color: AppColors.cardGrey),
                  readOnly: true,
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
                      fontSize: 16,
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
