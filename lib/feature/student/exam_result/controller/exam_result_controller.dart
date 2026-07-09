import 'package:eub_connect/feature/student/exam_result/model/exam_result_model.dart';
import 'package:get/get.dart';

class ExamResultController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const ExamResultModel().obs;
}
