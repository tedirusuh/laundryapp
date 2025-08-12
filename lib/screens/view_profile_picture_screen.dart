import 'package:flutter/material.dart';

class ViewProfilePictureScreen extends StatelessWidget {
  final String imageUrl;

  const ViewProfilePictureScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          // Widget untuk zoom dan pan gambar
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.asset(
            // Menggunakan Image.asset untuk data statis
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
