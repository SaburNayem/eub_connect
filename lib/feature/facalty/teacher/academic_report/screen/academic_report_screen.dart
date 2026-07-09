import 'package:eub_connect/feature/facalty/teacher/academic_report/controller/academic_report_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AcademicReportScreen extends StatelessWidget {
  const AcademicReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AcademicReportController>(
      create: AcademicReportController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
