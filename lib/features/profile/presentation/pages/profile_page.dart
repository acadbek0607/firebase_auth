// profile_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/bloc_status.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fire_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:fire_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:fire_auth/features/profile/presentation/widgets/edit_profile_page.dart';
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
  String _selectedLanguage = 'English (USA)';
  String _selectedFlagPath = 'assets/flags/us.svg';
  Locale? _prevLocale;
  bool _showForm = false;

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

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final user = state.user;
          if (user != null) {
            context.read<ProfileBloc>().add(LoadProfile(uid: user.uid));
          }
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.darkest,
              title: Text(
                tr('profile', context: context),
                style: Kstyle.textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              centerTitle: false,
              titleSpacing: 4.0,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                child: SvgPicture.asset('assets/svg/appBar_icon.svg'),
              ),
              actions: [
                IconButton(
                  icon: Image.asset('assets/img/logout.png', width: 32.0),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            body: state.status == BlocStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          20.0,
                          16.0,
                          0.0,
                        ),
                        child: ProfileCard(
                          profile:
                              state.profile ??
                              ProfileEntity(
                                uid: authUser?.uid ?? '',
                                email: authUser?.email ?? '',
                              ),
                          onLanguageTap: _showLanguageDialog,
                          selectedLanguage: _selectedLanguage,
                          selectedFlag: _selectedFlagPath,
                          onProfileTap: () {
                            setState(() {
                              _showForm = true;
                            });
                          },
                        ),
                      ),
                      if (_showForm || state.profile == null)
                        EditProfileForm(
                          showBack: state.profile != null,
                          onDismiss: () {
                            setState(() {
                              _showForm = false;
                            });
                          },
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
