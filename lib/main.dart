// lib/main.dart
import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Impor Firebase Core
import 'firebase_options.dart'; // Impor file konfigurasi yang dibuat oleh FlutterFire

void main() async {
  // Ubah menjadi async
  WidgetsFlutterBinding
      .ensureInitialized(); // Wajib ada sebelum inisialisasi Firebase
  await Firebase.initializeApp(
    // Inisialisasi Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus MaterialApp dengan ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: MaterialApp(
        title: 'Laundry Express',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFFE0F0FF),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
