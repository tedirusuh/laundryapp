import 'package:app_laundry/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigasi otomatis setelah beberapa detik
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });

    const Color primaryBlue = Color(0xFF2962FF);
    const Color lightBlueBg = Color.fromARGB(255, 139, 174, 240);

    return Scaffold(
      backgroundColor: lightBlueBg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/poto_splash.png',
                  height: 180), // Pastikan gambar ada
              const SizedBox(height: 32),
              const Text(
                'Laundry Express',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Solusi lengkap untuk semua kebutuhan cucian Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(color: primaryBlue),
            ],
          ),
        ),
      ),
    );
  }
}
