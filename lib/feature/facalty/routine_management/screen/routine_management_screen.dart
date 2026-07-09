import 'package:eub_connect/feature/facalty/routine_management/controller/routine_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class RoutineManagementScreen extends StatelessWidget {
  const RoutineManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<RoutineManagementController>(
      create: RoutineManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
