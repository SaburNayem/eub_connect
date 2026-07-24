import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/backend/supabase_backend.dart';
import 'package:eub_connect/feature/auth/model/app_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  SupabaseClient? get _client => SupabaseBackend.client;

  Future<AppResult<AppAccount>> restoreSession() async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    final user = client.auth.currentUser;
    if (user == null) {
      return const AppResult.failure(
        AppFailure(
          type: AppFailureType.authentication,
          message: 'No active session.',
        ),
      );
    }

    return _accountForUser(user.id);
  }

  Future<AppResult<AppAccount>> signIn({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return const AppResult.failure(
          AppFailure(
            type: AppFailureType.authentication,
            message: 'Invalid email or password.',
          ),
        );
      }
      return _accountForUser(user.id);
    } on AuthException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.authentication,
          message: error.message,
          detail: error,
        ),
      );
    } on PostgrestException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: error.message,
          detail: error,
        ),
      );
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to sign in. Please try again.',
          detail: error,
        ),
      );
    }
  }

  Future<AppResult<AppAccount?>> registerStudent({
    required String universityId,
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'university_id': universityId,
          'requested_role': 'student',
        },
      );

      final user = response.user;
      if (user == null) {
        return const AppResult.success(null);
      }

      if (response.session == null) {
        return const AppResult.success(null);
      }

      await client.from('profiles').upsert({
        'id': user.id,
        'university_id': universityId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'status': 'active',
      });

      return _accountForUser(user.id);
    } on AuthException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.authentication,
          message: error.message,
          detail: error,
        ),
      );
    } on PostgrestException catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.server,
          message: error.message,
          detail: error,
        ),
      );
    } catch (error) {
      return AppResult.failure(
        AppFailure(
          type: AppFailureType.unknown,
          message: 'Unable to register. Please try again.',
          detail: error,
        ),
      );
    }
  }

  Future<void> signOut() async {
    final client = _client;
    if (client != null) {
      await client.auth.signOut();
    }
  }

  Future<AppResult<AppAccount>> _accountForUser(String userId) async {
    final client = _client;
    if (client == null) {
      return AppResult.failure(SupabaseBackend.notConfiguredFailure());
    }

    final profile = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) {
      return const AppResult.failure(
        AppFailure(
          type: AppFailureType.notFound,
          message: 'Your profile is not set up yet. Contact an administrator.',
        ),
      );
    }

    final roleRow = await client
        .from('user_roles')
        .select('roles(code)')
        .eq('user_id', userId)
        .limit(1)
        .maybeSingle();

    final roleData = roleRow?['roles'];
    final roleCode = roleData is Map<String, dynamic>
        ? roleData['code'] as String?
        : null;

    return AppResult.success(
      AppAccount.fromProfile(
        profile: profile,
        role: portalRoleFromCode(roleCode),
      ),
    );
  }
}
