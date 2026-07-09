import 'package:eub_connect/feature/student/attendance_tracking/model/attendance_tracking_model.dart';
import 'package:get/get.dart';

class AttendanceTrackingController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AttendanceTrackingModel().obs;
}
