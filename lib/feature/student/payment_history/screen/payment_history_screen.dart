import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:eub_connect/feature/student/payment_history/controller/payment_history_controller.dart';
import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureModuleControllerScreen<PaymentHistoryController>(
      create: PaymentHistoryController.new,
      featureBuilder: (controller) => controller.model.value.feature,
    );
  }
}
