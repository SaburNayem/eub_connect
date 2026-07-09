import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ProfileController>(
      create: ProfileController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
