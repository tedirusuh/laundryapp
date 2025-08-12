// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String? photoUrl;
  final String role;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.role = 'customer',
  });

  // Fungsi ini dibuat lebih aman terhadap data yang hilang (null)
  factory UserModel.fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      uid: snap.id,
      // Jika ada data kosong, gunakan nilai default
      fullName: data['fullName'] as String? ?? 'Pengguna',
      email: data['email'] as String? ?? 'Email tidak diketahui',
      photoUrl: data['photoUrl'] as String?,
      role: data['role'] as String? ?? 'customer',
    );
  }
}
