// lib/profile_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:app_laundry/admin_screen.dart';
import 'package:app_laundry/app_routes.dart';
import 'package:app_laundry/providers/user_provider.dart';
import 'package:app_laundry/settings_screen.dart';
import 'package:app_laundry/view_profile_picture_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;
  final String _cloudinaryCloudName = 'dpuqwpily'; // Pastikan ini benar
  final String _cloudinaryUploadPreset = 'laundry_app'; // Pastikan ini benar

  // Fungsi untuk melihat foto jika ada
  void _viewProfilePicture(String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ViewProfilePictureScreen(imageUrl: photoUrl)));
    }
  }

  // Fungsi untuk memilih dan mengunggah gambar baru
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile == null) return;
    setState(() => _isUploading = true);

    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isUploading = false);
      return;
    }

    try {
      final uploadUrl = Uri.parse(
          'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload');
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = _cloudinaryUploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', pickedFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());
        final imageUrl = responseData['secure_url'];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'photoUrl': imageUrl});
        await Provider.of<UserProvider>(context, listen: false)
            .reloadUserData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Foto profil berhasil diperbarui!')));
        }
      } else {
        throw Exception('Gagal mengunggah gambar');
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.user == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final user = userProvider.user!;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Profil Saya'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  // ===============================================
                  // PERUBAHAN UTAMA ADA DI SINI: MENGGUNAKAN STACK
                  // ===============================================
                  child: Stack(
                    children: [
                      // WIDGET FOTO PROFIL (LAYER BAWAH)
                      GestureDetector(
                        onTap: () => _viewProfilePicture(user.photoUrl),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : (user.photoUrl == null || user.photoUrl!.isEmpty
                                  ? Icon(Icons.person,
                                      size: 60, color: Colors.grey[700])
                                  : null),
                        ),
                      ),
                      // TOMBOL EDIT (LAYER ATAS)
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
                            onPressed:
                                _pickAndUploadImage, // Panggil fungsi ganti foto
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ===============================================
                // AKHIR PERUBAHAN
                // ===============================================

                const SizedBox(height: 24),
                Text(user.fullName,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),

                if (user.role == 'admin') ...[
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminScreen()));
                    },
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('Buka Panel Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await fb_auth.FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 94, 214),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('LOGOUT',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
