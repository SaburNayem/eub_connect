import 'package:eub_connect/feature/facalty/system_activity/controller/system_activity_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SystemActivityScreen extends StatelessWidget {
  const SystemActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<SystemActivityController>(
      create: SystemActivityController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
