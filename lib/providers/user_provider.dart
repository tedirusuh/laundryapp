// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_laundry/models/user_model.dart'; // Pastikan path ini benar

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get user => _user;

  UserProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
    } else {
      await _loadUserData(firebaseUser.uid);
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      _user = UserModel.fromSnap(doc);
    }
  }

  Future<void> reloadUserData() async {
    if (_auth.currentUser != null) {
      await _loadUserData(_auth.currentUser!.uid);
      notifyListeners();
    }
  }
}
