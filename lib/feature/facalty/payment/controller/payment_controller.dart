import 'package:eub_connect/feature/facalty/payment/model/payment_model.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const PaymentModel().obs;
}
