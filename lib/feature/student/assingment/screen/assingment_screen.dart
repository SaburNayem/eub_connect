import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/assingment/controller/assingment_controller.dart';
import 'package:flutter/material.dart';

class AssingmentScreen extends StatelessWidget {
  const AssingmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AssingmentController>(
      create: AssingmentController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
