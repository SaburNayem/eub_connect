import 'package:eub_connect/feature/facalty/teacher/manage_course/assignment_and_quiz/model/assignment_and_quiz_model.dart';
import 'package:get/get.dart';

class AssignmentAndQuizController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AssignmentAndQuizModel().obs;
}
