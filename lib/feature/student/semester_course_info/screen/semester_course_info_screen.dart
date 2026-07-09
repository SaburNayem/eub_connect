import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/semester_course_info/controller/semester_course_info_controller.dart';
import 'package:flutter/material.dart';

class SemesterCourseInfoScreen extends StatelessWidget {
  const SemesterCourseInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<SemesterCourseInfoController>(
      create: SemesterCourseInfoController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
