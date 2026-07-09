import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/student_discussion_forum/controller/student_discussion_forum_controller.dart';
import 'package:flutter/material.dart';

class StudentDiscussionForumScreen extends StatelessWidget {
  const StudentDiscussionForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<StudentDiscussionForumController>(
      create: StudentDiscussionForumController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
