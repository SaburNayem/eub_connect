import 'package:eub_connect/feature/facalty/teacher/academic_report/model/academic_report_model.dart';
import 'package:get/get.dart';

class AcademicReportController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AcademicReportModel().obs;
}
