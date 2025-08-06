// lib/order_detail_screen.dart
import 'package:app_laundry/providers/order_provider.dart' as my_order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final my_order.Order order;
  const OrderDetailScreen({super.key, required this.order});

  // FUNGSI BARU UNTUK UPDATE STATUS KE FIRESTORE
  Future<void> updateOrderStatus(String newStatus) async {
    // Memperbarui dokumen di koleksi 'orders' berdasarkan ID
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order.id)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #${order.id.substring(0, 6)}...'),
        backgroundColor: const Color(0xFFE0F0FF),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFE0F0FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (order.status == 'Selesai'
                                ? Colors.green
                                : Colors.orange)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: order.status == 'Selesai'
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Harga: Rp. ${order.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const Divider(height: 40),

                const Text(
                  'Aksi Pengguna:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Tombol ini hanya muncul jika status pesanan BUKAN 'Selesai'
                if (order.status != 'Selesai')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        updateOrderStatus('Selesai');
                        // Tampilkan pesan konfirmasi
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Status pesanan diubah menjadi Selesai!')),
                        );
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: const Text('Tandai Pesanan Sebagai Selesai'),
                    ),
                  ),

                // Tampilkan pesan ini jika sudah selesai
                if (order.status == 'Selesai')
                  const Text('Pesanan ini sudah selesai.'),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
