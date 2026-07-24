import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/registration/controller/registration_controller.dart';
import 'package:eub_connect/feature/auth/registration/screen/widget/photo_field.dart';
import 'package:eub_connect/feature/auth/widget/auth_panel.dart';
import 'package:eub_connect/feature/auth/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({this.onAuthenticated, super.key});

  final VoidCallback? onAuthenticated;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(RegistrationController());
  }

  Future<void> _register() async {
    if (!_controller.validate()) {
      Get.snackbar(
        'Registration required',
        'Please complete the required profile fields.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    final session = ensureAuthSession();
    final success = await session.registerStudent(_controller.registrationData);
    if (!mounted) return;
    if (!success) {
      Get.snackbar(
        'Registration failed',
        session.lastError.value ?? 'Please check your information.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    if (session.isAuthenticated && widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          session.lastError.value ??
              'Student account registered. Continue with login.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<RegistrationController>()) {
      Get.delete<RegistrationController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKey,
      child: AuthPanel(
        title: 'Create Account',
        subtitle: 'Create a local demo student account',
        buttonLabel: 'Register',
        onSubmit: _register,
        children: [
          Obx(
            () => PhotoField(
              selected: _controller.photoPath.value != null,
              onTap: _controller.markPhotoSelected,
            ),
          ),
          const SizedBox(height: 14),
          AuthTextField(
            label: 'User ID',
            icon: Icons.badge_outlined,
            controller: _controller.userIdController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'User ID is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AuthTextField(
            label: 'Full Name',
            icon: Icons.person_outline,
            controller: _controller.fullNameController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AuthTextField(
            label: 'Password',
            icon: Icons.lock_outline,
            controller: _controller.passwordController,
            obscureText: true,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AuthTextField(
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            controller: _controller.phoneNumberController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AuthTextField(
            label: 'Email Address',
            icon: Icons.email_outlined,
            controller: _controller.emailAddressController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return 'Email address is required';
              }
              if (!email.contains('@')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
