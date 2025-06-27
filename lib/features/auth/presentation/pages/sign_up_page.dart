import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/core/constants/notifier.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _onSignUpPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthBloc>().add(SignUpRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), centerTitle: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Center(
              child: Column(
                children: [
                  Spacer(flex: 4),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: Kstyle.textFieldStyle.copyWith(
                        labelText: 'Email',
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
                            labelText: 'Password',
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
                      onPressed: _onSignUpPressed,
                      style: Kstyle.buttonStyle.copyWith(
                        minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 48),
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      trailing: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/signin'),
                        child: Text("Sign In"),
                      ),
                      title: Text("Already have an account?"),
                    ),
                  ),
                  if (state is Loading)
                    Center(child: const CircularProgressIndicator.adaptive()),
                  Spacer(flex: 4),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is Authenticated) {
            currentUserNotifier.value = state.user;
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }
}
