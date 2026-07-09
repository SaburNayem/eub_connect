import 'package:eub_connect/feature/facalty/user_role_management/controller/user_role_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class UserRoleManagementScreen extends StatelessWidget {
  const UserRoleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<UserRoleManagementController>(
      create: UserRoleManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
