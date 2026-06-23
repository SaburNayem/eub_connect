import 'package:eub_connect/feature/auth/login/screen/login_screen.dart';
import 'package:eub_connect/feature/auth/registration/screen/registration_screen.dart';
import 'package:eub_connect/feature/auth/widget/auth_switcher.dart';
import 'package:eub_connect/feature/auth/widget/brand_header.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showRegister = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BrandHeader(),
                  const SizedBox(height: 28),
                  AuthSwitcher(
                    showRegister: _showRegister,
                    onChanged: (value) {
                      setState(() {
                        _showRegister = value;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _showRegister
                        ? const RegistrationScreen(key: ValueKey('register'))
                        : const LoginScreen(key: ValueKey('login')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
