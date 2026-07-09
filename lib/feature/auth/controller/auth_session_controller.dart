import 'package:eub_connect/feature/auth/model/static_account.dart';
import 'package:eub_connect/feature/auth/registration/model/registration_model.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:get/get.dart';

class AuthSessionController extends GetxController {
  final currentAccount = Rxn<StaticAccount>();

  StaticAccount get account => currentAccount.value ?? staticAccounts.first;

  PortalRole get role => account.role;

  void signIn(StaticAccount account) {
    currentAccount.value = account;
  }

  void register(RegistrationModel data) {
    currentAccount.value = StaticAccount(
      id: data.userId,
      fullName: data.fullName,
      email: data.emailAddress,
      password: data.password,
      role: data.role,
      department: data.role.subtitle,
    );
  }

  void signOut() {
    currentAccount.value = null;
  }
}

AuthSessionController ensureAuthSession() {
  if (Get.isRegistered<AuthSessionController>()) {
    return Get.find<AuthSessionController>();
  }

  return Get.put(AuthSessionController(), permanent: true);
}
