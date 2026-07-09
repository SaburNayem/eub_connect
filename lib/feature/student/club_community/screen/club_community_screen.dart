import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/club_community/controller/club_community_controller.dart';
import 'package:flutter/material.dart';

class ClubCommunityScreen extends StatelessWidget {
  const ClubCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<ClubCommunityController>(
      create: ClubCommunityController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
