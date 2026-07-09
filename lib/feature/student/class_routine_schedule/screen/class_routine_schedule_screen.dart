import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/class_routine_schedule/controller/class_routine_schedule_controller.dart';
import 'package:flutter/material.dart';

class ClassRoutineScheduleScreen extends StatelessWidget {
  const ClassRoutineScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ClassRoutineScheduleController>(
      create: ClassRoutineScheduleController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
