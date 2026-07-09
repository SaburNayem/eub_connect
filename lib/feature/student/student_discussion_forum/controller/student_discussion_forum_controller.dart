import 'package:eub_connect/feature/student/student_discussion_forum/model/student_discussion_forum_model.dart';
import 'package:get/get.dart';

class StudentDiscussionForumController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const StudentDiscussionForumModel().obs;
}
