import 'package:flutter/material.dart';
import 'package:app_laundry/models/order_model.dart';
import 'package:app_laundry/screens/create_order_screen.dart';
import 'package:app_laundry/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_laundry/utils/constants.dart'; // Impor konstanta

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _activeOrders = [];
  bool _isLoading = true;

  // ignore: prefer_typing_uninitialized_variables
  var _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (_currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$API_URL/orders.php?user_id=${_currentUser!.id}'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            _activeOrders = (responseData['orders'] as List)
                .map((orderJson) => Order.fromJson(orderJson))
                .toList();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat pesanan.')));
      }
    }
    setState(() => _isLoading = false);
  }

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
              padding: EdgeInsets.only(left: 4.0),
              child: Text('Pesanan Aktif',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_activeOrders.isEmpty)
              const Center(child: Text('Tidak ada pesanan aktif.'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activeOrders.length,
                itemBuilder: (ctx, i) {
                  final order = _activeOrders[i];
                  return _buildOrderStatusCard(context: context, order: order);
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
        if (_currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Anda harus login terlebih dahulu untuk memesan.')));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreateOrderScreen(serviceTitle: title)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: size,
              height: size,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard(
      {required BuildContext context, required Order order}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.local_laundry_service,
                color: Color(0xFF2962FF), size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.title} (${order.weight.toStringAsFixed(0)} pcs)',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.status,
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            ),
            Text(
              '#${order.id}',
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
