import 'package:flutter/material.dart';
import 'package:app_laundry/models/order_model.dart';
import 'package:app_laundry/screens/create_order_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // Data contoh untuk menggantikan database
  static final List<Order> activeOrders = [];

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid untuk kategori layanan
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
            // Judul "Pesanan Aktif"
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text('Pesanan Aktif',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
            const SizedBox(height: 12),
            // Daftar pesanan
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeOrders.length,
              itemBuilder: (ctx, i) {
                final order = activeOrders[i];
                return _buildOrderStatusCard(
                    context: context, order: OrdersScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk ikon layanan
  Widget _buildServiceCategory(
      BuildContext context, String title, String imagePath,
      {double size = 45.0}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateOrderScreen(serviceTitle: title)));
      },
      child: Container(/* ... Sisa kode tidak berubah ... */),
    );
  }

  // Widget untuk kartu pesanan
  Widget _buildOrderStatusCard(
      {required BuildContext context, required OrdersScreen order}) {
    return Card(/* ... Sisa kode tidak berubah ... */);
  }
}
