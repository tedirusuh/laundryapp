// lib/admin_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = false;

  // --- FUNGSI PENGARSIPAN DENGAN LOGIKA BARU ---
  Future<void> _archiveOldOrders() async {
    setState(() => _isLoading = true);

    try {
      // Tentukan batas waktu (30 hari yang lalu)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      // 1. Ambil SEMUA pesanan yang statusnya "Selesai" dari Firestore
      // Query ini tidak memerlukan index komposit.
      final completedOrdersQuery = FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'Selesai');

      final snapshot = await completedOrdersQuery.get();

      if (snapshot.docs.isEmpty) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Tidak ada pesanan "Selesai" untuk diperiksa.')));
        setState(() => _isLoading = false);
        return;
      }

      // 2. Filter pesanan yang lebih tua dari 30 hari SECARA MANUAL di aplikasi
      final List<QueryDocumentSnapshot> ordersToArchive = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Ambil timestamp dari data
        final Timestamp createdAt = data['createdAt'] ?? Timestamp.now();
        // Jika tanggal pesanan lebih lama dari 30 hari yang lalu, tambahkan ke daftar arsip
        if (createdAt.toDate().isBefore(thirtyDaysAgo)) {
          ordersToArchive.add(doc);
        }
      }

      if (ordersToArchive.isEmpty) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Tidak ada pesanan "Selesai" yang lebih tua dari 30 hari.')));
        setState(() => _isLoading = false);
        return;
      }

      // 3. Gunakan batch untuk mengupdate semua pesanan yang perlu diarsipkan
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in ordersToArchive) {
        batch.update(doc.reference, {'status': 'Diarsipkan'});
      }

      // 4. Jalankan semua update
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Berhasil mengarsipkan ${ordersToArchive.length} pesanan.')),
        );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Aksi Administratif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _archiveOldOrders,
              icon: _isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3),
                    )
                  : const Icon(Icons.archive_outlined),
              label: Text(_isLoading
                  ? 'Memproses...'
                  : 'Arsipkan Pesanan Lama (> 30 hari)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aksi ini akan mengubah status pesanan yang telah "Selesai" lebih dari 30 hari menjadi "Diarsipkan" dan tidak akan tampil di daftar pesanan pengguna.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
