// lib/screens/orders_screen.dart
import 'package:app_laundry/create_order_screen.dart';
import 'package:app_laundry/order_detail_screen.dart';
import 'package:app_laundry/providers/order_provider.dart'; // <-- Impor halaman detail
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final activeOrders = orderProvider.orders;

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
          if (activeOrders.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Belum ada pesanan aktif.',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeOrders.length,
              itemBuilder: (ctx, i) => _buildOrderStatusCard(
                // Kirim context dan seluruh objek order
                context: context,
                order: activeOrders[i],
              ),
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

  // Modifikasi widget ini agar bisa di-klik
  Widget _buildOrderStatusCard({
    required BuildContext context,
    required Order order,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // <-- Dibungkus dengan InkWell
        onTap: () {
          // Navigasi ke halaman detail
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
                        color: order.status == 'Sudah selesai'
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '#${order.id.substring(20)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
