import 'package:flutter/material.dart';
import 'package:app_laundry/screens/home_screen.dart';
import 'package:app_laundry/screens/login_screen.dart';
import 'package:app_laundry/screens/register_screen.dart';
import 'package:app_laundry/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
  };
}
