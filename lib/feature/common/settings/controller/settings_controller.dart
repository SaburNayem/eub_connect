import 'package:eub_connect/feature/common/settings/model/settings_model.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const SettingsModel().obs;
}
