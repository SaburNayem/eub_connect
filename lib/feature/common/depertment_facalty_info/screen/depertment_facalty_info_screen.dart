import 'package:eub_connect/feature/common/depertment_facalty_info/controller/depertment_facalty_info_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class DepertmentFacaltyInfoScreen extends StatelessWidget {
  const DepertmentFacaltyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<DepertmentFacaltyInfoController>(
      create: DepertmentFacaltyInfoController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
