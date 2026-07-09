import 'package:eub_connect/feature/facalty/teacher/dashboard/model/dashboard_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const DashboardModel().obs;
}
