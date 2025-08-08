// lib/create_order_screen.dart

import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  final String serviceTitle;
  const CreateOrderScreen({super.key, required this.serviceTitle});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _weightController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _whatsappController = TextEditingController();

  double _totalPrice = 0.0;
  late double _pricePerItem;
  String _selectedPaymentMethod = 'DANA'; // Default

  @override
  void initState() {
    super.initState();
    _setPriceBasedOnService();
    _weightController.addListener(_calculatePrice);
  }

  void _setPriceBasedOnService() {
    switch (widget.serviceTitle.toLowerCase()) {
      case 'setrika':
        _pricePerItem = 5000;
        break;
      case 'satuan':
        _pricePerItem = 8000;
        break;
      case 'timbangan':
        _pricePerItem = 7000;
        break;
      case 'karpet':
        _pricePerItem = 10000;
        break;
      case 'sepatu':
        _pricePerItem = 25000;
        break;
      default:
        _pricePerItem = 7000;
    }
  }

  void _calculatePrice() {
    final quantity = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _totalPrice = quantity * _pricePerItem;
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Layanan ${widget.serviceTitle}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Berat (kg) atau Jumlah (pcs)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Harga: Rp. $_pricePerItem / item',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Total Harga: Rp. $_totalPrice',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'Metode Pembayaran',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: [
                  'DANA',
                  'GoPay',
                  'Transfer BRI',
                  'Transfer Mandiri',
                  'Transfer BNI'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20), // Memberikan sedikit ruang
              ElevatedButton(
                onPressed: () {
                  final quantity = double.tryParse(_weightController.text) ?? 0;
                  if (quantity > 0) {
                    Provider.of<OrderProvider>(context, listen: false).addOrder(
                      widget.serviceTitle,
                      quantity,
                      _pricePerItem,
                      _nameController.text,
                      _addressController.text,
                      _whatsappController.text,
                      _selectedPaymentMethod,
                    );
                    Navigator.of(context).pop();
                  } else {
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
      ),
    );
  }
}
