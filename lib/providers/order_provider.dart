// lib/providers/order_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// --- Bagian Class Order tidak ada perubahan ---
class Order {
  final String id;
  final String title;
  final String status;
  final double price;
  final double weight;
  final Timestamp createdAt;
  final String customerName;
  final String customerAddress;
  final String customerWhatsapp;
  final String paymentMethod;
  final String notes;

  Order({
    required this.id,
    required this.title,
    required this.status,
    required this.price,
    required this.weight,
    required this.createdAt,
    required this.customerName,
    required this.customerAddress,
    required this.customerWhatsapp,
    required this.paymentMethod,
    required this.notes,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    return Order(
      id: doc.id,
      title: data['title'] as String? ?? 'Tanpa Judul',
      status: data['status'] as String? ?? 'Status Tidak Diketahui',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      customerName: data['customerName'] as String? ?? 'Tanpa Nama',
      customerAddress: data['customerAddress'] as String? ?? 'Tanpa Alamat',
      customerWhatsapp: data['customerWhatsapp'] as String? ?? '-',
      paymentMethod: data['paymentMethod'] as String? ?? 'Cash',
      notes: data['notes'] as String? ?? '',
    );
  }
}

// --- Perubahan utama ada di kelas OrderProvider ---
class OrderProvider with ChangeNotifier {
  double _totalUnpaidAmount = 0.0;
  double get totalUnpaidAmount => _totalUnpaidAmount;

  OrderProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _calculateTotalUnpaidAmount();
      } else {
        _totalUnpaidAmount = 0.0;
        notifyListeners();
      }
    });
  }

  // FUNGSI INI DIPERBAIKI
  void _calculateTotalUnpaidAmount() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Dengarkan perubahan pada pesanan yang statusnya "Selesai"
    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        // HANYA HITUNG TAGIHAN JIKA STATUSNYA "SELESAI"
        .where('status', isEqualTo: 'Selesai')
        .snapshots()
        .listen((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['price'] as num?)?.toDouble() ?? 0.0;
      }
      _totalUnpaidAmount = total;
      notifyListeners();
    });
  }

  // FUNGSI INI JUGA DIPERBAIKI
  // Setelah bayar, ubah status pesanan "Selesai" menjadi "Lunas"
  Future<void> markFinishedOrdersAsPaid() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'Selesai') // Cari semua yang "Selesai"
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in querySnapshot.docs) {
      // Ubah statusnya menjadi "Lunas"
      batch.update(doc.reference, {'status': 'Lunas'});
    }
    await batch.commit();
    // Total tagihan akan otomatis terhitung ulang menjadi 0 karena listener di atas
  }
}
