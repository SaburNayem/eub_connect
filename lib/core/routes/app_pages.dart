import 'package:eub_connect/core/routes/app_routes.dart';
import 'package:eub_connect/feature/auth/screen/auth_screen.dart';
import 'package:eub_connect/feature/home/screen/home_screen.dart';
import 'package:get/get.dart';

class AppPages {
  const AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.auth, page: () => const AuthScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  ];
}
