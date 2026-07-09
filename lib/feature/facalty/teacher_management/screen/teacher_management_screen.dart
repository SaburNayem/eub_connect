import 'package:eub_connect/feature/facalty/teacher_management/controller/teacher_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class TeacherManagementScreen extends StatelessWidget {
  const TeacherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<TeacherManagementController>(
      create: TeacherManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
