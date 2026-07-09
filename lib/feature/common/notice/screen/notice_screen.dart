import 'package:eub_connect/feature/common/notice/controller/notice_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<NoticeController>(
      create: NoticeController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
