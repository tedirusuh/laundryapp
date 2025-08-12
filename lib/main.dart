// lib/main.dart

import 'package:app_laundry/providers/order_provider.dart';
import 'package:app_laundry/providers/user_provider.dart';
import 'package:app_laundry/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- LANGKAH 1: Impor paket untuk format tanggal ---
import 'package:intl/intl_standalone.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- LANGKAH 2: Inisialisasi format tanggal Indonesia ---
  // Baris ini akan "mengajari" aplikasi Anda format tanggal untuk 'id_ID'
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kode Anda yang lain di sini sudah benar
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Laundry',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
              scaffoldBackgroundColor: const Color(0xFFE0F0FF),
              brightness: Brightness.light,
              cardColor: Colors.white,
            ),
            darkTheme: ThemeData.dark().copyWith(
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
