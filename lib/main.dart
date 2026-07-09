import 'package:eub_connect/app.dart';
import 'package:eub_connect/feature/auth/controller/auth_session_controller.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ensureAuthSession();
  runApp(const EubConnectApp());
}
