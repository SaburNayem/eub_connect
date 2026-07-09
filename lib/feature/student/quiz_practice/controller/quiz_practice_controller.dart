import 'package:eub_connect/feature/student/quiz_practice/model/quiz_practice_model.dart';
import 'package:get/get.dart';

class QuizPracticeController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const QuizPracticeModel().obs;
}
