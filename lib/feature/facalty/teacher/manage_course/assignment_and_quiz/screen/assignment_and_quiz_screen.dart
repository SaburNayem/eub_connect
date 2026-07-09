import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/controller/assignment_and_quiz_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AssignmentAndQuizScreen extends StatelessWidget {
  const AssignmentAndQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AssignmentAndQuizController>(
      create: AssignmentAndQuizController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
