import 'dart:io';

import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _organizationController = TextEditingController();

  String? _photoUrl;
  File? _pickedImage;
  bool _isProfileSaved = false;

  String _selectedLanguage = 'English (USA)';
  String _selectedFlag = '🇺🇸';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state is Authenticated
        ? (context.read<AuthBloc>().state as Authenticated).user
        : null;

    if (user != null) {
      context.read<ProfileBloc>().add(LoadProfile(uid: user.uid));
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      final authUser = context.read<AuthBloc>().state is Authenticated
          ? (context.read<AuthBloc>().state as Authenticated).user
          : null;
      if (authUser == null) return;

      final profile = ProfileEntity(
        uid: authUser.uid,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        profession: _professionController.text.trim(),
        organization: _organizationController.text.trim(),
        email: authUser.email ?? '',
        photoUrl: _photoUrl,
      );

      context.read<ProfileBloc>().add(SaveProfile(profile));
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Choose a language',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLangOption('O‘zbek (Lotin)', '🇺🇿'),
              _buildLangOption('Русский', '🇷🇺'),
              _buildLangOption('English (USA)', '🇺🇸'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLangOption(String label, String flag) {
    return RadioListTile(
      value: label,
      groupValue: _selectedLanguage,
      onChanged: (val) {
        setState(() {
          _selectedLanguage = val!;
          _selectedFlag = flag;
        });
      },
      title: Text('$flag  $label', style: const TextStyle(color: Colors.white)),
      activeColor: Colors.teal,
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedPageNotifier.value = 4;

    final authUser = context.read<AuthBloc>().state is Authenticated
        ? (context.read<AuthBloc>().state as Authenticated).user
        : null;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _fullNameController.text = state.profile.fullName;
          _phoneController.text = state.profile.phone;
          _professionController.text = state.profile.profession;
          _organizationController.text = state.profile.organization;
          _photoUrl = state.profile.photoUrl;
          _isProfileSaved = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                  Navigator.pushReplacementNamed(context, '/signin');
                },
              ),
            ],
          ),
          body: state is ProfileLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isProfileSaved
                      ? _buildProfileCardView(authUser)
                      : _buildProfileForm(authUser),
                ),
          bottomNavigationBar: NavbarWidget(),
        );
      },
    );
  }

  Widget _buildProfileForm(authUser) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _pickedImage != null
                    ? FileImage(_pickedImage!)
                    : (_photoUrl != null
                              ? NetworkImage(_photoUrl!)
                              : const AssetImage('assets/img/default.png'))
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
            _buildTextField('Full Name', _fullNameController),
            const SizedBox(height: 12),
            _buildTextField('Phone', _phoneController),
            const SizedBox(height: 12),
            _buildTextField('Profession', _professionController),
            const SizedBox(height: 12),
            _buildTextField('Organization', _organizationController),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: authUser?.email ?? '',
              enabled: false,
              decoration: Kstyle.textFieldStyle.copyWith(labelText: 'Email'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitProfile,
              style: Kstyle.buttonStyle,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCardView(authUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: const Color(0xFF2C2C2E),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fullNameController.text,
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_professionController.text} • ${_organizationController.text}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${_phoneController.text}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Email: ${authUser?.email ?? ""}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _showLanguageDialog,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedLanguage),
              Text(_selectedFlag, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: Kstyle.textFieldStyle.copyWith(labelText: label),
      validator: (val) =>
          val == null || val.isEmpty ? '$label is required' : null,
    );
  }
}
