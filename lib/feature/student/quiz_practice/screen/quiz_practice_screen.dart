import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/quiz_practice/controller/quiz_practice_controller.dart';
import 'package:flutter/material.dart';

class QuizPracticeScreen extends StatelessWidget {
  const QuizPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<QuizPracticeController>(
      create: QuizPracticeController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
