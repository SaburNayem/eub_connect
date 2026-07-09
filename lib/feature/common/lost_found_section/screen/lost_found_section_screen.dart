import 'package:eub_connect/feature/common/lost_found_section/controller/lost_found_section_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class LostFoundSectionScreen extends StatelessWidget {
  const LostFoundSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<LostFoundSectionController>(
      create: LostFoundSectionController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
