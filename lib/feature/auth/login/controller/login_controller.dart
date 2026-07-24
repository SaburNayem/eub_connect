import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:eub_connect/feature/auth/login/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isSubmitting = false.obs;

  LoginModel get loginData {
    return LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  void fillDemoAccount({required String identifier}) {
    emailController.text = identifier;
    passwordController.text = '123456';
  }

  Future<bool> submit() async {
    if (!validate()) {
      return false;
    }

    isSubmitting.value = true;
    final data = loginData;
    final success = await ensureAuthSession().signIn(
      email: data.email,
      password: data.password,
    );
    isSubmitting.value = false;
    return success;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
