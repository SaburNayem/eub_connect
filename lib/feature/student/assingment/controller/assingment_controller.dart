import 'package:eub_connect/feature/student/assingment/model/assingment_model.dart';
import 'package:get/get.dart';

class AssingmentController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const AssingmentModel().obs;
}
