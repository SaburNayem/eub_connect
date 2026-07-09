import 'package:eub_connect/feature/facalty/depertment_management/controller/depertment_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class DepertmentManagementScreen extends StatelessWidget {
  const DepertmentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<DepertmentManagementController>(
      create: DepertmentManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
