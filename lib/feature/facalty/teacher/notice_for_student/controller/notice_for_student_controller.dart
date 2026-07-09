import 'package:eub_connect/feature/facalty/teacher/notice_for_student/model/notice_for_student_model.dart';
import 'package:get/get.dart';

class NoticeForStudentController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const NoticeForStudentModel().obs;
}
