import 'package:app_laundry/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/screens/admin_screen.dart';
import 'package:app_laundry/screens/settings_screen.dart';
import 'package:app_laundry/screens/view_profile_picture_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- DATA PROFIL STATIS (CONTOH) ---
  // Anda bisa mengubah nilai-nilai ini untuk melihat perbedaannya
  final String userName = 'Budi Santoso';
  final String userEmail = 'budi.santoso@example.com';
  final String profilePictureAsset =
      'assets/profile_pic.jpg'; // Pastikan ada gambar contoh di folder assets
  final String userRole =
      'admin'; // Ganti menjadi 'customer' untuk menyembunyikan tombol admin

  // --- FUNGSI SIMULASI UNTUK MENGGANTI FOTO ---
  void _pickAndUploadImage(BuildContext context) {
    // Menampilkan pesan bahwa ini hanya simulasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi: Membuka galeri untuk memilih foto...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- BAGIAN HEADER PROFIL (LENGKAP) ---
            Center(
              child: Stack(
                children: [
                  // Widget untuk foto profil
                  GestureDetector(
                    onTap: () {
                      // Navigasi untuk melihat foto ukuran penuh
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfilePictureScreen(
                              imageUrl: profilePictureAsset),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'profilePicture', // Tag untuk animasi
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: AssetImage(profilePictureAsset),
                      ),
                    ),
                  ),
                  // Tombol edit di atas foto profil
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.white, size: 20),
                        onPressed: () => _pickAndUploadImage(
                            context), // Panggil fungsi ganti foto
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              userName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            // --- BAGIAN TOMBOL PANEL ADMIN ---
            if (userRole == 'admin') ...[
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()),
                  );
                },
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Buka Panel Admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],

            const SizedBox(height: 40),

            // --- BAGIAN TOMBOL LOGOUT ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Kembali ke halaman login dan hapus semua halaman sebelumnya
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
