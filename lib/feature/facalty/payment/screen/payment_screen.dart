import 'package:eub_connect/feature/facalty/payment/controller/payment_controller.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<PaymentController>(
      create: PaymentController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
