import 'package:eub_connect/core/routes/app_routes.dart';
import 'package:eub_connect/feature/auth/login/screen/login_screen.dart';
import 'package:eub_connect/feature/auth/registration/screen/registration_screen.dart';
import 'package:eub_connect/feature/auth/widget/auth_switcher.dart';
import 'package:eub_connect/feature/auth/widget/brand_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final showRegister = false.obs;

  void setMode(bool value) {
    showRegister.value = value;
  }
}

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController _controller = Get.put(AuthController());

  void _openAuthenticatedApp() {
    Get.offAllNamed(AppRoutes.home);
  }

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
                  Obx(
                    () => Column(
                      children: [
                        AuthSwitcher(
                          showRegister: _controller.showRegister.value,
                          onChanged: _controller.setMode,
                        ),
                        const SizedBox(height: 22),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _controller.showRegister.value
                              ? RegistrationScreen(
                                  key: const ValueKey('register'),
                                  onAuthenticated: _openAuthenticatedApp,
                                )
                              : LoginScreen(
                                  key: const ValueKey('login'),
                                  onAuthenticated: _openAuthenticatedApp,
                                ),
                        ),
                      ],
                    ),
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
