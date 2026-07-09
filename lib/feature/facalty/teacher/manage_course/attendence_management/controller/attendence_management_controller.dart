import 'package:eub_connect/feature/facalty/teacher/manage_course/attendence_management/model/attendence_management_model.dart';
import 'package:get/get.dart';

class AttendenceManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AttendenceManagementModel().obs;
}
