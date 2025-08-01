import 'package:app_laundry/login_screen.dart';
import 'package:app_laundry/register_screen.dart'; // Impor file register screen
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Impor file splash screen yang baru dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Express',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => RegisterScreen(),
      },
    );
  }
}
