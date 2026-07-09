import 'package:eub_connect/feature/common/settings/controller/settings_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<SettingsController>(
      create: SettingsController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
