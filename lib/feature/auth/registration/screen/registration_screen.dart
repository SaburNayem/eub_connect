import 'package:eub_connect/feature/auth/registration/controller/registration_controller.dart';
import 'package:eub_connect/feature/auth/registration/screen/widget/photo_field.dart';
import 'package:eub_connect/feature/auth/widget/auth_panel.dart';
import 'package:eub_connect/feature/auth/widget/auth_text_field.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _controller = RegistrationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _register() {
    final registrationData = _controller.registrationData;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registered: ${registrationData.fullName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPanel(
      title: 'Create Account',
      subtitle: 'Add your university profile details',
      buttonLabel: 'Register',
      onSubmit: _register,
      children: [
        PhotoField(
          onTap: () {
            _controller.photoPath = 'selected_profile_photo';
          },
        ),
        const SizedBox(height: 18),
        AuthTextField(
          label: 'Student ID',
          icon: Icons.badge_outlined,
          controller: _controller.studentIdController,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Full Name',
          icon: Icons.person_outline,
          controller: _controller.fullNameController,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Password',
          icon: Icons.lock_outline,
          controller: _controller.passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          controller: _controller.phoneNumberController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Email Address',
          icon: Icons.email_outlined,
          controller: _controller.emailAddressController,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
