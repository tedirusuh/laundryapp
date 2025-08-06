// lib/orders_screen.dart
import 'package:app_laundry/create_order_screen.dart';
import 'package:app_laundry/laundry_detail_screen.dart';
import 'package:app_laundry/order_detail_screen.dart';
import 'package:app_laundry/providers/order_provider.dart' as my_order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider masih digunakan untuk membuat pesanan

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data pengguna yang sedang login saat ini
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      appBar: AppBar(
        title: const Text('Layanan Kami'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildServiceCategory(context, 'Setrika', 'assets/setrika.png',
                  size: 45),
              _buildServiceCategory(context, 'Satuan', 'assets/satuan.png',
                  size: 60),
              _buildServiceCategory(
                  context, 'Timbangan', 'assets/timbangan.png',
                  size: 55),
              _buildServiceCategory(context, 'Karpet', 'assets/karpet.png',
                  size: 45),
              _buildServiceCategory(context, 'Sepatu', 'assets/sepatu.png',
                  size: 45),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Pesanan Aktif',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 12),

          // MENGGUNAKAN STREAMBUILDER UNTUK MENAMPILKAN DATA DARI FIRESTORE
          StreamBuilder<QuerySnapshot>(
            // Mengambil data dari koleksi 'orders' & memfilternya berdasarkan ID pengguna
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userId',
                    isEqualTo: currentUser
                        ?.uid) // Hanya tampilkan pesanan milik pengguna ini
                .orderBy('createdAt',
                    descending: true) // Urutkan dari yang terbaru
                .snapshots(),
            builder: (context, snapshot) {
              // Tampilkan loading indicator saat data sedang diambil
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Tampilkan pesan jika tidak ada data pesanan
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Belum ada pesanan aktif.',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                );
              }

              // Jika ada data, tampilkan dalam bentuk daftar
              final orderDocs = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderDocs.length,
                itemBuilder: (ctx, i) {
                  // Mengubah setiap dokumen Firestore menjadi objek Order
                  final order = my_order.Order.fromFirestore(orderDocs[i]);
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
              // Jika class yang benar adalah LaundryDetailScreen, ubah menjadi:
              // builder: (context) => LaundryDetailScreen(order: order),
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
                    Text(
                      order.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.status,
                      style: TextStyle(
                        color: order.status == 'Selesai'
                            ? Colors.green.shade600
                            : Colors.orange.shade600,
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
