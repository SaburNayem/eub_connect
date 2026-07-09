import 'package:eub_connect/feature/student/tution_fee/model/tution_fee_model.dart';
import 'package:get/get.dart';

class TutionFeeController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const TutionFeeModel().obs;
}
