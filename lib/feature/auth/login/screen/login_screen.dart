import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/login/controller/login_controller.dart';
import 'package:eub_connect/feature/auth/widget/auth_panel.dart';
import 'package:eub_connect/feature/auth/widget/auth_text_field.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.onAuthenticated, super.key});

  final VoidCallback? onAuthenticated;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(LoginController());
  }

  Future<void> _login() async {
    if (!_controller.validate()) {
      Get.snackbar(
        'Login required',
        'Please enter your email and password.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    final success = await _controller.submit();
    if (!mounted) return;
    final session = ensureAuthSession();
    if (!success) {
      Get.snackbar(
        'Login failed',
        session.lastError.value ?? 'Please check your email and password.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in as ${session.account.role.label}')),
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _controller.formKey,
        child: AuthPanel(
          title: 'Welcome Back',
          subtitle: 'Sign in with your university account',
          buttonLabel: _controller.isSubmitting.value
              ? 'Signing in...'
              : 'Login',
          onSubmit: _controller.isSubmitting.value ? () {} : _login,
          children: [
            AuthTextField(
              label: 'Student/Teacher ID or Email',
              icon: Icons.badge_outlined,
              controller: _controller.emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final identifier = value?.trim() ?? '';
                if (identifier.isEmpty) {
                  return 'ID or email is required';
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
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _DemoAccountsPanel(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _DemoAccountsPanel extends StatelessWidget {
  const _DemoAccountsPanel({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    final accounts = DemoStore.instance.demoLoginAccounts;
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
            'Demo Accounts',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap a role to fill the demo ID and password. Role access still comes from the credentials.',
            style: TextStyle(color: Color(0xFF667085), height: 1.35),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final account in accounts)
                ActionChip(
                  avatar: Icon(account.role.icon, size: 18),
                  label: Text(account.role.label),
                  tooltip:
                      '${account.universityId} / ${account.email} / password 123456',
                  onPressed: () {
                    controller.fillDemoAccount(
                      identifier: account.universityId,
                    );
                    Get.snackbar(
                      'Demo account filled',
                      '${account.role.label}: ${account.universityId} / 123456',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(14),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
