import 'package:eub_connect/feature/auth/registration/model/registration_model.dart';
import 'package:flutter/material.dart';

class RegistrationController {
  final studentIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();

  String? photoPath;

  RegistrationModel get registrationData {
    return RegistrationModel(
      studentId: studentIdController.text.trim(),
      fullName: fullNameController.text.trim(),
      password: passwordController.text,
      phoneNumber: phoneNumberController.text.trim(),
      emailAddress: emailAddressController.text.trim(),
      photoPath: photoPath,
    );
  }

  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
  }
}
