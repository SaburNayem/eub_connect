import 'package:eub_connect/feature/facalty/routine_management/model/routine_management_model.dart';
import 'package:get/get.dart';

class RoutineManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const RoutineManagementModel().obs;
}
