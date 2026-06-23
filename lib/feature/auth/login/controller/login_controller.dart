import 'package:eub_connect/feature/auth/login/model/login_model.dart';
import 'package:flutter/material.dart';

class LoginController {
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();

  LoginModel get loginData {
    return LoginModel(
      studentId: studentIdController.text.trim(),
      password: passwordController.text,
    );
  }

  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();
  }
}
