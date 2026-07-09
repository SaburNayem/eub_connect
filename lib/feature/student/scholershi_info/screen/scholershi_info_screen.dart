import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/scholershi_info/controller/scholershi_info_controller.dart';
import 'package:flutter/material.dart';

class ScholershiInfoScreen extends StatelessWidget {
  const ScholershiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ScholershiInfoController>(
      create: ScholershiInfoController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
