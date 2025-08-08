// lib/profile_screen.dart
import 'dart:io';
import 'package:app_laundry/settings_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_laundry/app_routes.dart';
import 'package:app_laundry/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  XFile? _pickedImageFile;
  String? _profileImageUrl;
  bool _isUploading = false;

  final String _cloudinaryCloudName =
      'dpuqwpily6'; // Ganti dengan Cloud Name Anda
  final String _cloudinaryApiKey =
      '424219972319734'; // Ganti dengan API Key Anda
  final String _cloudinaryUploadPreset =
      'laundry_app_preset'; // Ganti dengan upload preset Anda

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data();
      if (userData != null && userData['photoUrl'] != null) {
        setState(() {
          _profileImageUrl = userData['photoUrl'];
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = pickedFile;
          _isUploading = true;
        });
        await _uploadImageToCloudinary(pickedFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih foto: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _uploadImageToCloudinary(XFile file) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Anda harus login untuk mengganti foto profil.')),
        );
      }
      setState(() {
        _isUploading = false;
      });
      return;
    }

    try {
      final uploadUrl = Uri.parse(
          'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload');
      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = _cloudinaryUploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());
        final imageUrl = responseData['secure_url'];

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'photoUrl': imageUrl});

        setState(() {
          _profileImageUrl = imageUrl;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
          );
        }
      } else {
        final errorResponse =
            json.decode(await response.stream.bytesToString());
        throw 'Gagal mengunggah gambar ke Cloudinary: ${errorResponse['error']['message']}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto: ${e.toString()}')),
        );
      }
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (_isUploading) {
      return const CircularProgressIndicator(color: Colors.white);
    } else if (_pickedImageFile != null && !kIsWeb) {
      return Image.file(File(_pickedImageFile!.path), fit: BoxFit.cover);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return Image.network(_profileImageUrl!, fit: BoxFit.cover);
    } else {
      return const Icon(Icons.person, size: 80, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const Color primaryBlue = Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
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
            GestureDetector(
              onTap: () => _showPicker(context),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: _buildProfileImage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.user.fullName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            _buildProfileTextField(
              label: 'full name',
              icon: Icons.person_outline,
              controller: TextEditingController(text: widget.user.fullName),
            ),
            const SizedBox(height: 16),
            _buildProfileTextField(
              label: 'email',
              icon: Icons.email_outlined,
              controller: TextEditingController(text: widget.user.email),
            ),
            const SizedBox(height: 16),
            _buildProfileTextField(
              label: 'password',
              icon: Icons.lock_outline,
              isPassword: true,
              controller: TextEditingController(text: widget.user.password),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.login, (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
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
  }

  Widget _buildProfileTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.visibility_off, color: Colors.grey),
              )
            : null,
      ),
    );
  }
}
