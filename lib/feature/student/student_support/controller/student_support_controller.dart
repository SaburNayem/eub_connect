import 'package:eub_connect/feature/student/student_support/model/student_support_model.dart';
import 'package:get/get.dart';

class StudentSupportController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const StudentSupportModel().obs;
}
