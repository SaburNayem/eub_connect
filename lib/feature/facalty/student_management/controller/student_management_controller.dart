import 'package:eub_connect/feature/facalty/student_management/model/student_management_model.dart';
import 'package:get/get.dart';

class StudentManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const StudentManagementModel().obs;
}
