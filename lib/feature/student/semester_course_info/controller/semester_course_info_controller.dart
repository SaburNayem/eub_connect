import 'package:eub_connect/feature/student/semester_course_info/model/semester_course_info_model.dart';
import 'package:get/get.dart';

class SemesterCourseInfoController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const SemesterCourseInfoModel().obs;
}
