import 'package:eub_connect/feature/facalty/user_role_management/model/user_role_management_model.dart';
import 'package:get/get.dart';

class UserRoleManagementController extends GetxController {
  final moduleStatus = 'Ready'.obs;
  final model = const UserRoleManagementModel().obs;
}
