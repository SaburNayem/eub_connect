import 'package:eub_connect/app.dart';
import 'package:eub_connect/core/backend/supabase_backend.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBackend.initialize();
  ensureAuthSession();
  runApp(const EubConnectApp());
}
