// lib/main.dart
import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:provider/provider.dart'; // Impor provider

void main() {
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
