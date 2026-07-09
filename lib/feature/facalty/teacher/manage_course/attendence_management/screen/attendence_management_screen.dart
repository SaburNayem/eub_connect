import 'package:eub_connect/feature/facalty/teacher/manage_course/attendence_management/controller/attendence_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AttendenceManagementScreen extends StatelessWidget {
  const AttendenceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AttendenceManagementController>(
      create: AttendenceManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
