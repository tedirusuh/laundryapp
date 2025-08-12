// lib/app_routes.dart

import 'package:app_laundry/home_screen.dart'; // TAMBAHKAN INI
import 'package:app_laundry/login_screen.dart';
import 'package:app_laundry/register_screen.dart';
import 'package:app_laundry/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home'; // TAMBAHKAN INI

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const RegisterScreen(),
        home: (context) => const HomeScreen(), // TAMBAHKAN INI
      };
}
