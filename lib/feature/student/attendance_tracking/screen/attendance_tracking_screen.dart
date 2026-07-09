import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/attendance_tracking/controller/attendance_tracking_controller.dart';
import 'package:flutter/material.dart';

class AttendanceTrackingScreen extends StatelessWidget {
  const AttendanceTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<AttendanceTrackingController>(
      create: AttendanceTrackingController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
