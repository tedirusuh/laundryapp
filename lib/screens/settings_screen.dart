import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/screens/theme_provider.dart'; // Impor provider tema

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Fungsi simulasi untuk menampilkan dialog
  void _showFakeDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          // Menggunakan Consumer untuk mendapatkan instance ThemeProvider
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Mode Gelap'),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  // Memanggil method pada provider untuk mengubah tema
                  themeProvider.toggleTheme();
                },
                secondary: const Icon(Icons.dark_mode_outlined),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Ganti Email'),
            onTap: () => _showFakeDialog(
              context,
              'Simulasi',
              'Ini adalah aksi untuk mengganti email.',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ganti Password'),
            onTap: () => _showFakeDialog(
              context,
              'Simulasi',
              'Ini adalah aksi untuk mengganti password.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Bahasa'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
