import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/exam_result/controller/exam_result_controller.dart';
import 'package:flutter/material.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ExamResultController>(
      create: ExamResultController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
