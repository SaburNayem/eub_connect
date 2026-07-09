import 'package:eub_connect/feature/common/event_management/model/event_management_model.dart';
import 'package:get/get.dart';

class EventManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const EventManagementModel().obs;
}
