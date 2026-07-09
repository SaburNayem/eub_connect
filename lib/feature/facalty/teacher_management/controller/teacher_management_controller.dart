import 'package:eub_connect/feature/facalty/teacher_management/model/teacher_management_model.dart';
import 'package:get/get.dart';

class TeacherManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const TeacherManagementModel().obs;
}
