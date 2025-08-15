// lib/screens/create_order_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_laundry/screens/login_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  final String serviceTitle;
  const CreateOrderScreen({super.key, required this.serviceTitle});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  double _totalPrice = 0.0;
  late double _pricePerItem;
  String _selectedPaymentMethod = 'DANA';
  bool _isLoading = false;

  // ignore: prefer_typing_uninitialized_variables
  var _currentUser;

  @override
  void initState() {
    super.initState();
    _setPriceBasedOnService();
    _weightController.addListener(_calculatePrice);
    if (_currentUser != null) {
      _nameController.text = _currentUser!.name;
    }
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
    setState(() => _totalPrice = quantity * _pricePerItem);
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus login terlebih dahulu.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.52/laundry_api/orders.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': _currentUser!.id,
          'title': widget.serviceTitle,
          'customer_name': _nameController.text,
          'customer_address': _addressController.text,
          'customer_whatsapp': _whatsappController.text,
          'price': _totalPrice,
          'weight': double.tryParse(_weightController.text) ?? 0,
          'notes': _notesController.text,
          'payment_method': _selectedPaymentMethod,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseData['message'])));
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Terjadi kesalahan jaringan.')));
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesan Layanan ${widget.serviceTitle}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Informasi Pengantaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _addressController,
                labelText: 'Alamat Lengkap',
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _whatsappController,
                labelText: 'Nomor WhatsApp',
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const Divider(height: 30),
            const Text('Detail Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _weightController,
              labelText: 'Berat (kg) atau Jumlah (pcs)',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) =>
                  (double.tryParse(v!) == null || double.parse(v) <= 0)
                      ? 'Masukkan angka valid'
                      : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _notesController,
                labelText: 'Catatan (opsional)',
                maxLines: 3),
            const SizedBox(height: 20),
            Text('Harga: Rp ${_pricePerItem.toStringAsFixed(0)} / item',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Harga: Rp ${_totalPrice.toStringAsFixed(0)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(
                  labelText: 'Metode Pembayaran',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              items: ['DANA', 'GoPay', 'Transfer BRI']
                  .map(
                      (v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2962FF),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Konfirmasi Pesanan',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildTextField(
          {required TextEditingController controller,
          required String labelText,
          TextInputType? keyboardType,
          int maxLines = 1,
          String? Function(String?)? validator}) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white),
        validator: validator,
      );

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _whatsappController.dispose();
    _weightController.removeListener(_calculatePrice);
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
