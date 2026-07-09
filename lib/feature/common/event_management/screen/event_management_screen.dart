import 'package:eub_connect/feature/common/event_management/controller/event_management_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<EventManagementController>(
      create: EventManagementController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
