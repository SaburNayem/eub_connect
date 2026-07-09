import 'package:eub_connect/feature/facalty/teacher/dashboard/controller/dashboard_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<DashboardController>(
      create: DashboardController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
