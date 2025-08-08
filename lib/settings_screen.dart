// lib/settings_screen.dart
import 'package:app_laundry/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reauthPasswordController =
      TextEditingController();

  Future<void> _reauthenticateUser(Function onAuthenticated) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verifikasi Kata Sandi'),
          content: TextField(
            controller: _reauthPasswordController,
            obscureText: true,
            decoration:
                const InputDecoration(hintText: "Masukkan kata sandi Anda"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && user.email != null) {
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: _reauthPasswordController.text,
                    );
                    await user.reauthenticateWithCredential(credential);
                    if (mounted) {
                      Navigator.of(context).pop();
                      onAuthenticated();
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Verifikasi gagal: ${e.message}')),
                    );
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangeEmailDialog() async {
    _reauthenticateUser(() async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ganti Email'),
            content: TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: "Email baru"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.verifyBeforeUpdateEmail(_emailController.text);
                      // Atau jika ingin langsung update (tidak direkomendasikan untuk production):
                      // await user.updateEmail(_emailController.text);
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email berhasil diganti!')),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Gagal mengganti email: ${e.message}')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Gagal mengganti email: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _showChangePasswordDialog() async {
    _reauthenticateUser(() async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ganti Password'),
            content: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password baru (min 6 karakter)"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.updatePassword(_passwordController.text);
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Password berhasil diganti!')),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Gagal mengganti password: ${e.message}')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Gagal mengganti password: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Ganti Email'),
            onTap: _showChangeEmailDialog,
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ganti Password'),
            onTap: _showChangePasswordDialog,
          ),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
        ],
      ),
    );
  }
}
