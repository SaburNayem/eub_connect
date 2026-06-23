import 'package:eub_connect/feature/auth/login/controller/login_controller.dart';
import 'package:eub_connect/feature/auth/widget/auth_panel.dart';
import 'package:eub_connect/feature/auth/widget/auth_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    final loginData = _controller.loginData;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login ID: ${loginData.studentId}')));
  }

  @override
  Widget build(BuildContext context) {
    return AuthPanel(
      title: 'Welcome Back',
      subtitle: 'Login with your student account',
      buttonLabel: 'Login',
      onSubmit: _login,
      children: [
        AuthTextField(
          label: 'Student ID',
          icon: Icons.badge_outlined,
          controller: _controller.studentIdController,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Password',
          icon: Icons.lock_outline,
          controller: _controller.passwordController,
          obscureText: true,
        ),
      ],
    );
  }
}
