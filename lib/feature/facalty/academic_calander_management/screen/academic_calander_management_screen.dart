import 'package:eub_connect/feature/facalty/academic_calander_management/controller/academic_calander_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AcademicCalanderManagementScreen extends StatelessWidget {
  const AcademicCalanderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AcademicCalanderManagementController>(
      create: AcademicCalanderManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
