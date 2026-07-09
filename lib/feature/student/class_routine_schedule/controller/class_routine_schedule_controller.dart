import 'package:eub_connect/feature/student/class_routine_schedule/model/class_routine_schedule_model.dart';
import 'package:get/get.dart';

class ClassRoutineScheduleController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const ClassRoutineScheduleModel().obs;
}
