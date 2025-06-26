import 'package:fire_auth/core/constants/classes.dart';
import 'package:fire_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _signOut(BuildContext context) {
    context.read<AuthBloc>().add(SignOutRequested());
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthBloc>().state as Authenticated).user;
    return Scaffold(
      appBar: AppBar(title: Text('Welcome'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello ${user.email}!',
                style: Kstyle.textStyle.copyWith(fontSize: 20),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _signOut(context),
                style: Kstyle.buttonStyle,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
