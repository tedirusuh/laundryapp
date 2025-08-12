// lib/laundry_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_laundry/models/laundry_model.dart';

// =======================================================
// BAGIAN 1: KELAS UTAMA (Harus extends StatefulWidget)
// =======================================================
class LaundryDetailScreen extends StatefulWidget {
  final Laundry laundry;
  const LaundryDetailScreen({super.key, required this.laundry});

  @override
  State<LaundryDetailScreen> createState() => _LaundryDetailScreenState();
}

// =======================================================
// BAGIAN 2: KELAS STATE (Harus terhubung ke LaundryDetailScreen)
// =======================================================
class _LaundryDetailScreenState extends State<LaundryDetailScreen> {
  // Semua controller dan variabel state diletakkan di sini
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitOrderFromDetail() async {
    // Fungsi ini sudah benar, tidak perlu diubah
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Anda harus login untuk membuat pesanan.')));
      return;
    }

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _whatsappController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Harap isi semua kolom yang wajib diisi.')));
      return;
    }

    final double quantity = double.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah/berat harus lebih dari 0.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final double totalPrice = quantity * widget.laundry.price.toDouble();

      final Map<String, dynamic> orderData = {
        'userId': user.uid,
        'title': widget.laundry.title,
        'price': totalPrice,
        'status': 'Menunggu Penjemputan',
        'createdAt': Timestamp.now(),
        'weight': quantity,
        'notes': _notesController.text.trim(),
        'customerName': _nameController.text.trim(),
        'customerAddress': _addressController.text.trim(),
        'customerWhatsapp': _whatsappController.text.trim(),
        'paymentMethod': 'Cash',
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan berhasil ditambahkan!')));
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
  Widget build(BuildContext context) {
    // Seluruh kode tampilan (UI) Anda diletakkan di sini
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.laundry.title),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.laundry.imagePath,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesan Layanan ${widget.laundry.title}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp. ${widget.laundry.price.toStringAsFixed(0)} / item',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      controller: _nameController,
                      labelText: 'Nama Lengkap',
                      icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _addressController,
                      labelText: 'Alamat',
                      icon: Icons.home_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _whatsappController,
                      labelText: 'Nomor WhatsApp',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _quantityController,
                      labelText: 'Jumlah / Berat (kg)',
                      icon: Icons.line_weight,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller: _notesController,
                      labelText: 'Catatan (Opsional)',
                      icon: Icons.note_alt_outlined,
                      maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _submitOrderFromDetail,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          icon: _isLoading
              ? Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3),
                )
              : const Icon(Icons.add_shopping_cart),
          label: Text(_isLoading ? 'Memproses...' : 'Konfirmasi Pesanan'),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required IconData icon,
      TextInputType? keyboardType,
      int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
