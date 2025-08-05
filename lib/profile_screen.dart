import 'dart:io';

import 'package:app_laundry/settings_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_laundry/app_routes.dart';
import 'package:app_laundry/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  XFile? _pickedImageFile;

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = pickedFile;
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
              if (!kIsWeb)
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
    if (_pickedImageFile == null) {
      return const Icon(Icons.person, size: 80, color: Colors.white);
    } else {
      if (kIsWeb) {
        return Image.network(_pickedImageFile!.path, fit: BoxFit.cover);
      } else {
        return Image.file(File(_pickedImageFile!.path), fit: BoxFit.cover);
      }
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
              onTap: () {
                _showPicker(context);
              },
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

  // PINDAHKAN FUNGSI INI KE DALAM CLASS _ProfileScreenState
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
