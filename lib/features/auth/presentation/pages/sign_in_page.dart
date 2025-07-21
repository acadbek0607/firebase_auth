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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _onSignInPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthBloc>().add(SignInResquested(email, password));
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
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Spacer(flex: 4),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: Kstyle.textFieldStyle.copyWith(
                        labelText: tr('email', context: context),
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          obscureText: _obscure,
                          controller: _passwordController,
                          decoration: Kstyle.textFieldStyle.copyWith(
                            labelText: tr('password', context: context),
                          ),
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
                  ),
                  Spacer(),
                  Expanded(
                    child: ElevatedButton(
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
                  ),
                  Expanded(
                    child: ListTile(
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
                  ),
                  if (state.status == AuthStatus.loading)
                    Center(child: const CircularProgressIndicator.adaptive()),
                  Spacer(flex: 4),
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
