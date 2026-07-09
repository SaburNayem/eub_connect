import 'package:eub_connect/feature/facalty/result_academic_report/controller/result_academic_report_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class ResultAcademicReportScreen extends StatelessWidget {
  const ResultAcademicReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ResultAcademicReportController>(
      create: ResultAcademicReportController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
