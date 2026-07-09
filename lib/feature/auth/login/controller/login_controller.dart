import 'package:eub_connect/feature/auth/model/static_account.dart';
import 'package:eub_connect/feature/auth/login/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginModel get loginData {
    return LoginModel(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  StaticAccount? authenticate() {
    final data = loginData;
    return findStaticAccount(email: data.email, password: data.password);
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
