import 'package:eub_connect/feature/student/attendance_tracking/model/attendance_tracking_model.dart';
import 'package:get/get.dart';

class AttendanceTrackingController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AttendanceTrackingModel().obs;
  final selectedCourseIndex = 0.obs;

  CourseAttendance get selectedCourse {
    final courses = model.value.courses;
    if (courses.isEmpty) {
      throw StateError('No attendance courses available');
    }
    var index = selectedCourseIndex.value;
    if (index < 0) {
      index = 0;
    }
    if (index >= courses.length) {
      index = courses.length - 1;
    }
    return courses[index];
  }

  void selectCourse(int index) {
    final courses = model.value.courses;
    if (index < 0 || index >= courses.length) {
      return;
    }
    selectedCourseIndex.value = index;
  }
}
