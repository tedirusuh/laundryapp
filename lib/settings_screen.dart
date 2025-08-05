// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // State untuk mode gelap

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Ganti Email'),
            onTap: () {
              // TODO: Tampilkan dialog untuk ganti email
              // Fitur ini memerlukan backend (Firebase Auth)
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ganti Password'),
            onTap: () {
              // TODO: Tampilkan dialog untuk ganti password
              // Fitur ini memerlukan backend (Firebase Auth)
            },
          ),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
                // TODO: Tambahkan logika untuk mengubah tema aplikasi
              });
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
        ],
      ),
    );
  }
}
