import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/tution_fee/controller/tution_fee_controller.dart';
import 'package:flutter/material.dart';

class TutionFeeScreen extends StatelessWidget {
  const TutionFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<TutionFeeController>(
      create: TutionFeeController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
