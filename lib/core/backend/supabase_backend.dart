import 'package:eub_connect/core/backend/app_failure.dart';
import 'package:eub_connect/core/config/app_environment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseBackend {
  SupabaseBackend._();

  static final environment = AppEnvironment.fromDefines();
  static bool _initialized = false;

  static bool get isConfigured => environment.isSupabaseConfigured;

  static bool get isReady => isConfigured && _initialized;

  static SupabaseClient? get client {
    if (!isReady) {
      return null;
    }
    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    if (!isConfigured || _initialized) {
      return;
    }

    await Supabase.initialize(
      url: environment.supabaseUrl,
      publishableKey: environment.supabaseAnonKey,
      debug: false,
    );
    _initialized = true;
  }

  static AppFailure notConfiguredFailure() {
    return const AppFailure(
      type: AppFailureType.backendNotConfigured,
      message:
          'Supabase is not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY.',
    );
  }
}
