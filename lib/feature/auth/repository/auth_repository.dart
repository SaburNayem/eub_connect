import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/demo/demo_store.dart';
import 'package:eub_connect/feature/auth/model/app_account.dart';

class AuthRepository {
  AuthRepository({DemoStore? store}) : _store = store ?? DemoStore.instance;

  final DemoStore _store;

  Future<AppResult<AppAccount>> restoreSession() async {
    final account = _store.restoreSession();
    if (account == null) {
      return const AppResult.failure(
        AppFailure(
          type: AppFailureType.authentication,
          message: 'No active demo session.',
        ),
      );
    }
    return AppResult.success(AppAccount.fromDemo(account, _store));
  }

  Future<AppResult<AppAccount>> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final account = _store.signIn(identifier: email, password: password);
    if (account == null) {
      return const AppResult.failure(
        AppFailure(
          type: AppFailureType.authentication,
          message:
              'Invalid demo credentials. Use the ID/email and password from Demo Accounts.',
        ),
      );
    }
    return AppResult.success(AppAccount.fromDemo(account, _store));
  }

  Future<AppResult<AppAccount?>> registerStudent({
    required String universityId,
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final account = _store.registerStudent(
        universityId: universityId,
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );
      return AppResult.success(AppAccount.fromDemo(account, _store));
    } on StateError catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.validation,
          message: error.message,
          detail: error,
        ),
      );
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to create the demo student account.',
          detail: error,
        ),
      );
    }
  }

  Future<void> signOut() => _store.signOut();
}
