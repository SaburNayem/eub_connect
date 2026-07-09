import 'package:eub_connect/feature/facalty/system_activity/model/system_activity_model.dart';
import 'package:get/get.dart';

class SystemActivityController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const SystemActivityModel().obs;
}
