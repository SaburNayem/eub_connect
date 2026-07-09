import 'package:eub_connect/feature/facalty/teacher/manage_course/marks_result/controller/marks_result_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class MarksResultScreen extends StatelessWidget {
  const MarksResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<MarksResultController>(
      create: MarksResultController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
