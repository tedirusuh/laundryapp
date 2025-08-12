import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:app_laundry/provides/theme_provider.dart'; // Path diperbaiki
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Laundry App',
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: const Color(0xFFE0F0FF),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF2962FF),
                  foregroundColor: Colors.white,
                )),
            darkTheme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Colors.grey[900],
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey[850],
                )),
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
