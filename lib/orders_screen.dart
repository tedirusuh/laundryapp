import 'package:app_laundry/create_order_screen.dart';
import 'package:app_laundry/order_detail_screen.dart';
import 'package:app_laundry/providers/order_provider.dart' as my_order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Silakan login untuk melihat pesanan Anda.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      appBar: AppBar(
        title: const Text('Layanan Kami'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri untuk judul
          children: [
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildServiceCategory(context, 'Setrika', 'assets/setrika.png',
                    size: 25),
                _buildServiceCategory(
                    context, 'Satuan', 'assets/baju-removebg-preview.png',
                    size: 25),
                _buildServiceCategory(context, 'Timbangan',
                    'assets/Timbangan-removebg-preview (1).png',
                    size: 20),
                _buildServiceCategory(context, 'Karpet', 'assets/karpet.png',
                    size: 25),
                _buildServiceCategory(context, 'Sepatu', 'assets/sepatu.png',
                    size: 25),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 4.0), // Beri sedikit padding
              child: Text(
                'Pesanan Aktif',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              // =======================================================
              // FILTER HANYA UNTUK PESANAN AKTIF
              // =======================================================
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: currentUser.uid)
                  .where('status',
                      whereIn: ['Menunggu Penjemputan', 'Sedang Dikerjakan'])
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              // =======================================================
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Belum ada pesanan aktif.',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ),
                  );
                }

                final orderDocs = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderDocs.length,
                  itemBuilder: (ctx, i) {
                    final order = my_order.Order.fromFirestore(orderDocs[i]);
                    // Gunakan widget kartu pesanan Anda yang sudah diperbaiki
                    return _buildOrderStatusCard(
                      context: context,
                      order: order,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategory(
      BuildContext context, String title, String imagePath,
      {double size = 45.0}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateOrderScreen(serviceTitle: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: size,
              width: size,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red, size: 40);
              },
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================
  // KARTU PESANAN DENGAN NAMA PELANGGAN
  // =======================================================
  Widget _buildOrderStatusCard({
    required BuildContext context,
    required my_order.Order order,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                Icons.local_laundry_service_outlined,
                size: 40,
                color: Colors.grey[800],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- NAMA PELANGGAN TAMPIL DI SINI ---
                    Text(
                      order.customerName, // Tampilkan nama pelanggan
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Jenis layanan (dihapus karena sudah ada di nama)
                    // Text(order.title, ...),
                    Text(
                      order.status, // Tampilkan status
                      style: TextStyle(
                        color: Colors.orange.shade600, // Warna status aktif
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#${order.id.substring(0, 6)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
