import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/login/controller/login_controller.dart';
import 'package:eub_connect/feature/auth/model/static_account.dart';
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

  void _login() {
    if (!_controller.validate()) {
      Get.snackbar(
        'Login required',
        'Please enter your email and password.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    final account = _controller.authenticate();
    if (account == null) {
      Get.snackbar(
        'Invalid login',
        'Use one of the static role accounts shown below.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
      return;
    }

    ensureAuthSession().signIn(account);

    if (widget.onAuthenticated != null) {
      widget.onAuthenticated!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged in as ${account.role.label}')),
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
    return Form(
      key: _controller.formKey,
      child: AuthPanel(
        title: 'Welcome Back',
        subtitle: 'Login with a static EUB role account',
        buttonLabel: 'Login',
        onSubmit: _login,
        children: [
          AuthTextField(
            label: 'Email Address',
            icon: Icons.email_outlined,
            controller: _controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
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
              if (value.length < 4) {
                return 'Password must be at least 4 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _StaticCredentialList(
            onSelected: (account) {
              _controller.emailController.text = account.email;
              _controller.passwordController.text = account.password;
            },
          ),
        ],
      ),
    );
  }
}

class _StaticCredentialList extends StatelessWidget {
  const _StaticCredentialList({required this.onSelected});

  final ValueChanged<StaticAccount> onSelected;

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
            'Static login accounts',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final account in staticAccounts)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => onSelected(account),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: account.role.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            account.role.icon,
                            color: account.role.color,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${account.role.label}: ${account.email}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Password: ${account.password}',
                                style: const TextStyle(
                                  color: Color(0xFF667085),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.input_outlined,
                          color: Color(0xFF98A2B3),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
