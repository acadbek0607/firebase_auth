import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController professionController;
  final TextEditingController organizationController;
  final TextEditingController dobController;
  final File? pickedImage;
  final Function() pickImage;
  final Function() pickDateOfBirth;
  final String? email;
  final Function() submitProfile;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.professionController,
    required this.organizationController,
    required this.dobController,
    required this.pickedImage,
    required this.pickImage,
    required this.pickDateOfBirth,
    required this.email,
    required this.submitProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.transparent,
                backgroundImage: pickedImage != null
                    ? FileImage(pickedImage!)
                    : const AssetImage('assets/img/default.png')
                          as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    radius: 16,
                    child: const Icon(Icons.edit, size: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(tr('full_name'), fullNameController),
            const SizedBox(height: 12),
            _buildTextField(tr('phone'), phoneController),
            const SizedBox(height: 12),
            _buildTextField(tr('profession'), professionController),
            const SizedBox(height: 12),
            _buildTextField(tr('organization'), organizationController),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: pickDateOfBirth,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dobController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: tr('date_of_birth'),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? tr('date_required') : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: email ?? '',
              enabled: false,
              decoration: Kstyle.textFieldStyle.copyWith(
                labelText: tr('email'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitProfile,
              style: Kstyle.buttonStyle,
              child: Text(tr('save_profile')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: Kstyle.textFieldStyle.copyWith(labelText: label),
      validator: (val) =>
          val == null || val.isEmpty ? '$label ${tr('required')}' : null,
    );
  }
}
