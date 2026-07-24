import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/feature/auth/model/app_account.dart';
import 'package:eub_connect/feature/auth/registration/model/registration_model.dart';
import 'package:eub_connect/feature/auth/repository/auth_repository.dart';
import 'package:eub_connect/feature/home/model/static_feature.dart';
import 'package:get/get.dart';

class AuthSessionController extends GetxController {
  AuthSessionController({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;
  final currentAccount = Rxn<AppAccount>();
  final isLoading = false.obs;
  final lastError = RxnString();

  AppAccount get account => currentAccount.value ?? AppAccount.guest;

  PortalRole get role => account.role;

  bool get isAuthenticated => currentAccount.value != null;

  Future<bool> restoreSession() async {
    isLoading.value = true;
    lastError.value = null;
    final result = await _repository.restoreSession();
    isLoading.value = false;

    if (result.isSuccess) {
      currentAccount.value = result.requireData;
      return true;
    }

    if (result.failure?.type != AppFailureType.authentication) {
      lastError.value = result.failure?.message;
    }
    currentAccount.value = null;
    return false;
  }

  Future<bool> signIn({required String email, required String password}) async {
    isLoading.value = true;
    lastError.value = null;
    final result = await _repository.signIn(email: email, password: password);
    isLoading.value = false;

    if (result.isSuccess) {
      currentAccount.value = result.requireData;
      return true;
    }

    lastError.value = result.failure?.message;
    return false;
  }

  Future<bool> registerStudent(RegistrationModel data) async {
    isLoading.value = true;
    lastError.value = null;
    final result = await _repository.registerStudent(
      universityId: data.userId,
      fullName: data.fullName,
      email: data.emailAddress,
      password: data.password,
      phone: data.phoneNumber,
    );
    isLoading.value = false;

    if (result.isSuccess) {
      currentAccount.value = result.data;
      if (result.data == null) {
        lastError.value =
            'Registration received. Please verify your email before login.';
      }
      return true;
    }

    lastError.value = result.failure?.message;
    return false;
  }

  Future<void> signOut() async {
    await _repository.signOut();
    currentAccount.value = null;
  }
}

AuthSessionController ensureAuthSession() {
  if (Get.isRegistered<AuthSessionController>()) {
    return Get.find<AuthSessionController>();
  }

  return Get.put(AuthSessionController(), permanent: true);
}
