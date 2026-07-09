import 'package:eub_connect/feature/facalty/admin_facalty/controller/admin_facalty_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class AdminFacaltyScreen extends StatelessWidget {
  const AdminFacaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AdminFacaltyController>(
      create: AdminFacaltyController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
