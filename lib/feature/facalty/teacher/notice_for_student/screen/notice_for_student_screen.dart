import 'package:eub_connect/feature/facalty/teacher/notice_for_student/controller/notice_for_student_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class NoticeForStudentScreen extends StatelessWidget {
  const NoticeForStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<NoticeForStudentController>(
      create: NoticeForStudentController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
