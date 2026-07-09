import 'package:eub_connect/feature/student/payment_history/model/payment_history_model.dart';
import 'package:get/get.dart';

class PaymentHistoryController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const PaymentHistoryModel().obs;
}
