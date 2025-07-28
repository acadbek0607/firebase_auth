// profile_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _organizationController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _selectedDate;

  String _selectedLanguage = 'English (USA)';
  String _selectedFlagPath = 'assets/flags/us.svg';
  Locale? _prevLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_prevLocale != locale) {
      _prevLocale = locale;
      setState(() => _updateLanguageFromLocale(locale));
    }
  }

  void _updateLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'uz':
        _selectedLanguage = 'O‘zbek (Lotin)';
        _selectedFlagPath = 'assets/flags/uz.svg';
        break;
      case 'ru':
        _selectedLanguage = 'Русский';
        _selectedFlagPath = 'assets/flags/ru.svg';
        break;
      default:
        _selectedLanguage = 'English (USA)';
        _selectedFlagPath = 'assets/flags/us.svg';
    }
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    final user = state.status == AuthStatus.authenticated ? state.user : null;

    if (user != null) {
      context.read<ProfileBloc>().add(LoadProfile(uid: user.uid));
    }
  }

  void _showLanguageDialog() {
    LanguageDialog.show(
      context: context,
      currentLanguage: _selectedLanguage,
      currentFlagPath: _selectedFlagPath,
      onChanged: (lang, flagPath) {
        final local = _localeFromLanguage(lang);
        if (local != null) {
          context.setLocale(local);
        }
        setState(() {
          _selectedLanguage = lang;
          _selectedFlagPath = flagPath;
        });
      },
    );
  }

  Locale? _localeFromLanguage(String lang) {
    switch (lang) {
      case 'O‘zbek (Lotin)':
        return const Locale('uz');
      case 'Русский':
        return const Locale('ru');
      case 'English (USA)':
        return const Locale('en');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    final authUser = state.status == AuthStatus.authenticated
        ? state.user
        : null;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == BlocStatus.loaded) {
          _fullNameController.text = state.profile!.fullName;
          _phoneController.text = state.profile!.phone;
          _professionController.text = state.profile!.profession;
          _organizationController.text = state.profile!.organization;
          _selectedDate = state.profile!.dateOfBirth != null
              ? DateTime.tryParse(state.profile!.dateOfBirth!)
              : null;
          if (_selectedDate != null) {
            _dobController.text =
                "${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year}";
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr('profile', context: context),
              style: Kstyle.textStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            centerTitle: false,
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
          body: state.status == BlocStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ProfileCard(
                    fullName: 'Asadbek Mamutov',
                    phone: '+998906620706',
                    email: authUser?.email ?? '',
                    profession: 'Mobile developer',
                    organization: 'UIC',
                    dateOfBirth: '06.07.2000',
                    onLanguageTap: _showLanguageDialog,
                    selectedLanguage: _selectedLanguage,
                    selectedFlag: _selectedFlagPath,
                  ),
                ),
        );
      },
    );
  }
}
