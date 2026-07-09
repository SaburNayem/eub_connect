import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/registration/controller/registration_controller.dart';
import 'package:eub_connect/feature/auth/registration/screen/widget/photo_field.dart';
import 'package:eub_connect/feature/auth/widget/auth_panel.dart';
import 'package:eub_connect/feature/auth/widget/auth_text_field.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
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

  void _register() {
    if (!_controller.validate()) {
      Get.snackbar(
        'Registration required',
        'Please complete the required profile fields.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    ensureAuthSession().register(_controller.registrationData);

    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    final registrationData = _controller.registrationData;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registered: ${registrationData.fullName}')),
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
        subtitle: 'Add a static role profile for this demo',
        buttonLabel: 'Register',
        onSubmit: _register,
        children: [
          Obx(
            () => PhotoField(
              selected: _controller.photoPath.value != null,
              onTap: _controller.selectDemoPhoto,
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => _RoleChoiceField(
              selectedRole: _controller.selectedRole.value,
              onChanged: _controller.setRole,
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
              if (value.length < 4) {
                return 'Password must be at least 4 characters';
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

class _RoleChoiceField extends StatelessWidget {
  const _RoleChoiceField({
    required this.selectedRole,
    required this.onChanged,
  });

  final PortalRole selectedRole;
  final ValueChanged<PortalRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Type',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PortalRole.values.map((role) {
              final selected = role == selectedRole;
              return ChoiceChip(
                selected: selected,
                avatar: Icon(
                  role.icon,
                  size: 17,
                  color: selected ? AppColors.white : role.color,
                ),
                label: Text(role.label),
                labelStyle: TextStyle(
                  color: selected ? AppColors.white : AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
                selectedColor: role.color,
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: selected ? role.color : const Color(0xFFE3E6EA),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (_) => onChanged(role),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
