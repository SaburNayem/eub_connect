import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/student_support/controller/student_support_controller.dart';
import 'package:flutter/material.dart';

class StudentSupportScreen extends StatelessWidget {
  const StudentSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<StudentSupportController>(
      create: StudentSupportController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
