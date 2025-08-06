import 'package:app_laundry/login_screen.dart';
import 'package:app_laundry/register_screen.dart';
import 'package:app_laundry/splash_screen.dart';
import 'package:flutter/material.dart';
// Hapus import untuk laundry_detail_screen.dart dari sini

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  // Hapus laundryDetail dari daftar konstanta

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const RegisterScreen(),

        // Hapus laundryDetail dari daftar rute
      };
}
