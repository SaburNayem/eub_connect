import 'package:eub_connect/feature/auth/registration/model/registration_model.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();

  final photoPath = RxnString();
  final selectedRole = PortalRole.student.obs;

  RegistrationModel get registrationData {
    return RegistrationModel(
      userId: userIdController.text.trim(),
      fullName: fullNameController.text.trim(),
      password: passwordController.text,
      phoneNumber: phoneNumberController.text.trim(),
      emailAddress: emailAddressController.text.trim(),
      role: selectedRole.value,
      photoPath: photoPath.value,
    );
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  void selectDemoPhoto() {
    photoPath.value = 'selected_profile_photo';
  }

  void setRole(PortalRole role) {
    selectedRole.value = role;
  }

  @override
  void onClose() {
    userIdController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    super.onClose();
  }
}
