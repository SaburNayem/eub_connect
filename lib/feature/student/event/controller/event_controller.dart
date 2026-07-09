import 'package:eub_connect/feature/student/event/model/event_model.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const EventModel().obs;
}
