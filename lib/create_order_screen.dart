// lib/screens/create_order_screen.dart

import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  // Tambahkan variabel untuk menerima judul layanan
  final String serviceTitle;
  const CreateOrderScreen({super.key, required this.serviceTitle});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _weightController = TextEditingController();
  double _totalPrice = 0.0;

  // Contoh harga yang berbeda untuk setiap layanan
  late double _pricePerKg;

  @override
  void initState() {
    super.initState();
    // Atur harga berdasarkan judul layanan yang diterima
    _setPriceBasedOnService();
    _weightController.addListener(_calculatePrice);
  }

  void _setPriceBasedOnService() {
    switch (widget.serviceTitle.toLowerCase()) {
      case 'setrika':
        _pricePerKg = 5000;
        break;
      case 'satuan':
        _pricePerKg = 8000;
        break;
      case 'timbangan':
        _pricePerKg = 7000;
        break;
      case 'karpet':
        _pricePerKg = 10000;
        break;
      case 'sepatu':
        _pricePerKg = 25000;
        break;
      default:
        _pricePerKg = 7000;
    }
  }

  void _calculatePrice() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _totalPrice = weight * _pricePerKg;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tampilkan judul layanan yang diterima
        title: Text('Pesan Layanan ${widget.serviceTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Berat (kg) atau Jumlah (pcs)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Harga: Rp. $_pricePerKg / item',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Harga: Rp. $_totalPrice',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final quantity = double.tryParse(_weightController.text) ?? 0;
                if (quantity > 0) {
                  Provider.of<OrderProvider>(context, listen: false)
                      .addOrder(widget.serviceTitle, quantity, _pricePerKg);
                  Navigator.of(context).pop();
                } else {
                  // Tampilkan pesan jika input kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Harap masukkan jumlah atau berat terlebih dahulu.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Tambah ke Pesanan Aktif',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
