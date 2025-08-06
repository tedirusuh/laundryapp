// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order {
  final String id;
  final String title;
  final String status;
  final double price;
  final Timestamp createdAt;

  Order({
    required this.id,
    required this.title,
    required this.status,
    required this.price,
    required this.createdAt,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      title: data['title'] ?? '',
      status: data['status'] ?? 'Status Tidak Diketahui',
      price: (data['price'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _totalUnpaidAmount = 0.0;
  double get totalUnpaidAmount => _totalUnpaidAmount;

  OrderProvider() {
    _calculateTotalUnpaid();
  }

  void _calculateTotalUnpaid() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    _firestore
        .collection('orders')
        .where('userId', isEqualTo: currentUser.uid)
        .where('status', isNotEqualTo: 'Selesai')
        .snapshots()
        .listen((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['price'] ?? 0.0).toDouble();
      }
      _totalUnpaidAmount = total;
      notifyListeners();
    });
  }

  // FUNGSI BARU: Untuk mengubah status semua pesanan menjadi 'Selesai'
  Future<void> markAllOrdersAsPaid() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // 1. Ambil semua dokumen pesanan yang belum selesai
    final querySnapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: currentUser.uid)
        .where('status', isNotEqualTo: 'Selesai')
        .get();

    // 2. Gunakan batch write untuk efisiensi
    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'status': 'Selesai'});
    }

    // 3. Jalankan semua proses update sekaligus
    await batch.commit();
  }

  Future<void> addOrder(
      String title, double quantity, double pricePerItem) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final totalPrice = quantity * pricePerItem;
    String initialStatus;

    switch (title.toLowerCase()) {
      case 'setrika':
        initialStatus = 'Belum Disetrika';
        break;
      case 'sepatu':
        initialStatus = 'Proses Pembersihan';
        break;
      default:
        initialStatus = 'Masih Dicuci';
    }

    await _firestore.collection('orders').add({
      'userId': currentUser.uid,
      'title':
          '$title (${quantity.toStringAsFixed(0)} ${title == 'Timbangan' ? 'kg' : 'pcs'})',
      'status': initialStatus,
      'price': totalPrice,
      'createdAt': Timestamp.now(),
    });
  }
}
