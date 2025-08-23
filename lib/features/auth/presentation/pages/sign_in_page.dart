import 'package:easy_localization/easy_localization.dart';
import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _onSignInPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthBloc>().add(SignInRequested(email, password));
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
        title: Text(tr('sign_in', context: context)),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: _emailController,
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
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      TextFormField(
                        obscureText: _obscure,
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onSignInPressed,
                    style: Kstyle.buttonStyle.copyWith(
                      minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 48),
                      ),
                    ),
                    child: Text(
                      tr('sign_in'),
                      style: Kstyle.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    trailing: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/signup'),
                      child: Text(
                        tr('sign_up', context: context),
                        style: Kstyle.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(tr('dont_have_account', context: context)),
                  ),
                  if (state.status == AuthStatus.loading)
                    const Center(child: CircularProgressIndicator.adaptive()),
                  const SizedBox(height: 80),
                ],
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
