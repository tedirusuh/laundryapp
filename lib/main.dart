// lib/main.dart
import 'package:app_laundry/providers/order_provider.dart';
import 'package:app_laundry/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan MultiProvider untuk menempatkan semua provider di level teratas
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Laundry Express',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
              // Atur warna latar belakang untuk mode terang
              scaffoldBackgroundColor: const Color(0xFFE0F0FF),
              brightness: Brightness.light,
              cardColor: Colors.white,
            ),
            darkTheme: ThemeData.dark().copyWith(
              // Atur warna latar belakang untuk mode gelap
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.grey[900],
            ),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
