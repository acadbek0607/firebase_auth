// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/app_colors.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _accepted = false;

  void _onSignUpPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthBloc>().add(SignUpRequested(email, password));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('sign_up', context: context)),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: Kstyle.textStyle,
                      decoration: Kstyle.textFieldStyle.copyWith(
                        labelText: tr('email', context: context),
                      ),
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
                    SizedBox(height: 32),
                    Stack(
                      children: [
                        TextFormField(
                          obscureText: _obscure,
                          keyboardType: TextInputType.visiblePassword,
                          style: Kstyle.textStyle,
                          controller: _passwordController,
                          decoration: Kstyle.textFieldStyle.copyWith(
                            labelText: tr('password', context: context),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        Positioned(
                          right: 8,
                          top: 4,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _accepted ? _onSignUpPressed : null,
                      style: Kstyle.buttonStyle.copyWith(
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 48),
                        ),
                      ),
                      child: Text(
                        tr('sign_up'),
                        style: Kstyle.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _accepted = !_accepted;
                            });
                          },
                          icon: SvgPicture.asset(
                            _accepted
                                ? 'assets/svg/s_check.svg'
                                : 'assets/svg/check.svg',
                          ),
                        ),
                        Wrap(
                          children: [
                            Text(
                              tr('accept_privacy_policy', context: context) +
                                  ' ',
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/privacy'),
                              child: Text(
                                tr('privacy_policy', context: context),
                                style: const TextStyle(
                                  color: AppColors.link,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(tr('dont_have_account', context: context)),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/signin',
                          ),
                          child: Text(
                            tr('sign_in', context: context),
                            style: Kstyle.textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.status == AuthStatus.loading)
                      Center(child: const CircularProgressIndicator.adaptive()),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            currentUserNotifier.value = state.user;
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage.toString())),
            );
          }
        },
      ),
    );
  }
}
