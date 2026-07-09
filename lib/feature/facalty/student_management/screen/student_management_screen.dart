import 'package:eub_connect/feature/facalty/student_management/controller/student_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<StudentManagementController>(
      create: StudentManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
