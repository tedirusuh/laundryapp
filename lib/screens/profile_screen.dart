import 'package:app_laundry/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/screens/admin_screen.dart';
import 'package:app_laundry/screens/settings_screen.dart';
import 'package:app_laundry/screens/view_profile_picture_screen.dart';
import 'package:app_laundry/models/user_model.dart';
import 'package:app_laundry/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_laundry/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _profileUser;
  bool _isLoading = true;

  // ignore: prefer_typing_uninitialized_variables
  var _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    // Memastikan _currentUser tidak null sebelum memuat data
    if (_currentUser == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$API_URL/profile.php?user_id=${_currentUser!.id}'),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          _profileUser = User.fromJson(responseData['user']);
        });
      } else {
        if (mounted) {
          // Jika gagal memuat data profil, jangan kembali ke login, tapi tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat profil.')));
      }
    }
    setState(() => _isLoading = false);
  }

  void _pickAndUploadImage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi: Membuka galeri untuk memilih foto...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profileUser == null) {
      return const Center(child: Text('Gagal memuat data profil.'));
    }

    final profilePictureAsset = 'assets/profile_pic.jpg';
    final userRole = _profileUser!.role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
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
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfilePictureScreen(
                              imageUrl: profilePictureAsset),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'profilePicture',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: AssetImage(profilePictureAsset),
                      ),
                    ),
                  ),
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
                        onPressed: () => _pickAndUploadImage(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _profileUser!.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _profileUser!.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _currentUser = null;
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
