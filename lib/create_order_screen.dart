// lib/create_order_screen.dart

import 'package:flutter/material.dart';
// Impor yang dibutuhkan untuk Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateOrderScreen extends StatefulWidget {
  final String serviceTitle;
  const CreateOrderScreen({super.key, required this.serviceTitle});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // Controller untuk setiap input field
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _weightController = TextEditingController();

  // Variabel untuk state
  double _totalPrice = 0.0;
  late double _pricePerItem;
  String _selectedPaymentMethod = 'DANA'; // Default
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setPriceBasedOnService();
    // Panggil _calculatePrice setiap kali ada perubahan pada input berat/jumlah
    _weightController.addListener(_calculatePrice);
  }

  // Mengatur harga per item berdasarkan judul layanan
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
        _pricePerItem = 7000; // Harga default jika tidak cocok
    }
  }

  // Menghitung total harga secara otomatis
  void _calculatePrice() {
    final quantity = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _totalPrice = quantity * _pricePerItem;
    });
  }

  // Fungsi untuk menyimpan pesanan ke Firestore
  Future<void> _submitOrderToFirestore() async {
    // Validasi input sederhana
    final quantity = double.tryParse(_weightController.text) ?? 0;
    if (quantity <= 0 ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _whatsappController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Harap lengkapi Nama, Alamat, No. WhatsApp, dan Berat/Jumlah.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Gagal mendapatkan info pengguna. Silakan login ulang.')));
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Siapkan data pesanan
      final Map<String, dynamic> orderData = {
        'userId': user.uid, // Ini KUNCINYA agar pesanan tidak hilang
        'title': widget.serviceTitle,
        'price': _totalPrice,
        'status': 'Menunggu Penjemputan',
        'createdAt': Timestamp.now(),
        'weight': quantity,
        'customerName': _nameController.text,
        'customerAddress': _addressController.text,
        'customerWhatsapp': _whatsappController.text,
        'paymentMethod': _selectedPaymentMethod,
      };

      // Kirim data ke Firestore
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan berhasil dibuat!')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              _buildTextField(
                  controller: _nameController, labelText: 'Nama Lengkap'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _addressController, labelText: 'Alamat'),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _whatsappController,
                  labelText: 'Nomor WhatsApp',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _weightController,
                  labelText: 'Berat (kg) atau Jumlah (pcs)',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 20),
              Text('Harga: Rp. ${_pricePerItem.toStringAsFixed(0)} / item',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Total Harga: Rp. ${_totalPrice.toStringAsFixed(0)}',
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
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitOrderToFirestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('pesan sekarang',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper agar kode tidak berulang
  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
