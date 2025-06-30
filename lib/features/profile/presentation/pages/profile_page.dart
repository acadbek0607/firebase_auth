// profile_page.dart
import 'dart:io';

import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:fire_auth/ui/home/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

      context.read<ProfileBloc>().add(SaveProfile(profile));
    }
  }

  void _showLanguageDialog() {
    LanguageDialog.show(
      context: context,
      currentLanguage: _selectedLanguage,
      currentFlag: _selectedFlag,
      onChanged: (lang, flag) {
        setState(() {
          _selectedLanguage = lang;
          _selectedFlag = flag;
        });
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
                      ? ProfileCard(
                          fullName: _fullNameController.text,
                          phone: _phoneController.text,
                          email: authUser?.email ?? '',
                          profession: _professionController.text,
                          organization: _organizationController.text,
                          photoUrl: _photoUrl,
                          dateOfBirth: _dobController.text,
                          onEdit: () => setState(() => _isProfileSaved = false),
                          onLanguageTap: _showLanguageDialog,
                          selectedLanguage: _selectedLanguage,
                          selectedFlag: _selectedFlag,
                        )
                      : ProfileForm(
                          formKey: _formKey,
                          fullNameController: _fullNameController,
                          phoneController: _phoneController,
                          professionController: _professionController,
                          organizationController: _organizationController,
                          dobController: _dobController,
                          pickedImage: _pickedImage,
                          pickImage: _pickImage,
                          pickDateOfBirth: _pickDateOfBirth,
                          email: authUser?.email,
                          submitProfile: _submitProfile,
                        ),
                ),
          bottomNavigationBar: NavbarWidget(),
        );
      },
    );
  }
}
