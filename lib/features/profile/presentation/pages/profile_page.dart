import 'dart:io';

import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  final _dobController = TextEditingController();

  DateTime? _selectedDate;
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

  Future<void> _pickDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<String?> _uploadProfilePhoto(String uid, File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Upload failed: $e');
      return null;
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      final authUser = context.read<AuthBloc>().state is Authenticated
          ? (context.read<AuthBloc>().state as Authenticated).user
          : null;
      if (authUser == null) return;

      if (_pickedImage != null) {
        final uploadedUrl = await _uploadProfilePhoto(
          authUser.uid,
          _pickedImage!,
        );
        if (uploadedUrl != null) {
          _photoUrl = uploadedUrl;
        } else {
          // You can show a snackbar or fallback
          debugPrint('Failed to upload image');
        }
      }

      final profile = ProfileEntity(
        uid: authUser.uid,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        profession: _professionController.text.trim(),
        organization: _organizationController.text.trim(),
        email: authUser.email ?? '',
        photoUrl: _photoUrl,
        dateOfBirth: _selectedDate != null
            ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
            : null,
      );

      // ignore: use_build_context_synchronously
      context.read<ProfileBloc>().add(SaveProfile(profile));
    }
  }

  void _showLanguageDialog() {
    String tempLanguage = _selectedLanguage;
    String tempFlag = _selectedFlag;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: const Text(
                'Choose a language',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLangOptionDialog(
                    'O‘zbek (Lotin)',
                    '🇺🇿',
                    tempLanguage,
                    (lang, flag) {
                      setInnerState(() {
                        tempLanguage = lang;
                        tempFlag = flag;
                      });
                    },
                  ),
                  _buildLangOptionDialog('Русский', '🇷🇺', tempLanguage, (
                    lang,
                    flag,
                  ) {
                    setInnerState(() {
                      tempLanguage = lang;
                      tempFlag = flag;
                    });
                  }),
                  _buildLangOptionDialog(
                    'English (USA)',
                    '🇺🇸',
                    tempLanguage,
                    (lang, flag) {
                      setInnerState(() {
                        tempLanguage = lang;
                        tempFlag = flag;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // cancel
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLanguage = tempLanguage;
                      _selectedFlag = tempFlag;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLangOptionDialog(
    String label,
    String flag,
    String groupValue,
    Function(String, String) onSelected,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text('$flag  $label', style: const TextStyle(color: Colors.white)),
      trailing: Radio<String>(
        value: label,
        groupValue: groupValue,
        onChanged: (val) {
          if (val != null) onSelected(val, flag);
        },
        activeColor: Colors.teal,
      ),
      onTap: () {
        onSelected(label, flag);
      },
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
          _selectedDate = state.profile.dateOfBirth != null
              ? DateTime.tryParse(state.profile.dateOfBirth!)
              : null;
          if (_selectedDate != null) {
            _dobController.text =
                "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
          }
          _isProfileSaved = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
              child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
            ),
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
            GestureDetector(
              onTap: _pickDateOfBirth,
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dobController,
                  decoration: Kstyle.textFieldStyle.copyWith(
                    labelText: 'Date of Birth',
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? 'Date of Birth is required'
                      : null,
                ),
              ),
            ),
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isProfileSaved = false;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF2C2C2E),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: _photoUrl != null
                            ? NetworkImage(_photoUrl!)
                            : const AssetImage('assets/img/default.png')
                                  as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fullNameController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_professionController.text} • ${_organizationController.text}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Phone', _phoneController.text),
                  _infoRow('Email', authUser?.email ?? ''),
                  if (_selectedDate != null)
                    _infoRow(
                      'Date of Birth',
                      "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _showLanguageDialog,
            style: Kstyle.buttonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(const Color(0xFF2B2B2E)),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedLanguage),
                  Text(_selectedFlag, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
