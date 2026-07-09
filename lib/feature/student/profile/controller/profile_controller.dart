import 'package:eub_connect/feature/student/profile/model/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const ProfileModel().obs;
}
