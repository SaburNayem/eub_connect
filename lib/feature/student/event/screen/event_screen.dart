import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/event/controller/event_controller.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<EventController>(
      create: EventController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
