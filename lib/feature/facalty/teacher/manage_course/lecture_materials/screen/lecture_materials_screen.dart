import 'package:eub_connect/feature/facalty/teacher/manage_course/lecture_materials/controller/lecture_materials_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class LectureMaterialsScreen extends StatelessWidget {
  const LectureMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<LectureMaterialsController>(
      create: LectureMaterialsController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
