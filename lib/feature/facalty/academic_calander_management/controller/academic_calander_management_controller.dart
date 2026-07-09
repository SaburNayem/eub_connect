import 'package:eub_connect/feature/facalty/academic_calander_management/model/academic_calander_management_model.dart';
import 'package:get/get.dart';

class AcademicCalanderManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AcademicCalanderManagementModel().obs;
}
