import 'package:eub_connect/feature/facalty/teacher/manage_course/marks_result/model/marks_result_model.dart';
import 'package:get/get.dart';

class MarksResultController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const MarksResultModel().obs;
}
