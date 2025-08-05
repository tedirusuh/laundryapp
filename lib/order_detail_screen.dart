// lib/screens/order_detail_screen.dart
import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #${order.id.substring(20)}'),
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
              mainAxisSize:
                  MainAxisSize.min, // Membuat kartu seukuran kontennya
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
                        color: (order.status == 'Sudah selesai'
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
                          color: order.status == 'Sudah selesai'
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
                  'Informasi Tambahan:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title:
                      Text('Status pesanan akan diupdate oleh pihak laundry.'),
                  subtitle: Text(
                      'Anda akan menerima notifikasi jika status berubah.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
