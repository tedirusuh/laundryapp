import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => LoginScreen(),
        signup: (context) => RegisterScreen(),
      };
}
