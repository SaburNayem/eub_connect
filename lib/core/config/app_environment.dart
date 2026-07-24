class AppEnvironment {
  const AppEnvironment({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.storageBucket,
  });

  factory AppEnvironment.fromDefines() {
    return const AppEnvironment(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      storageBucket: String.fromEnvironment(
        'SUPABASE_STORAGE_BUCKET',
        defaultValue: 'app-files',
      ),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String storageBucket;

  bool get isSupabaseConfigured {
    return supabaseUrl.startsWith('https://') && supabaseAnonKey.length > 20;
  }
}
