import 'package:flutter/material.dart';

class CreateOrderScreen extends StatefulWidget {
  final String serviceTitle;
  const CreateOrderScreen({super.key, required this.serviceTitle});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController =
      TextEditingController(text: 'Budi Santoso'); // Contoh data
  final _addressController =
      TextEditingController(text: 'Jl. Merdeka No. 17, Jakarta');
  final _whatsappController = TextEditingController(text: '081234567890');
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  double _totalPrice = 0.0;
  late double _pricePerItem;
  String _selectedPaymentMethod = 'DANA';
  bool _isLoading = false;

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
    setState(() => _totalPrice = quantity * _pricePerItem);
  }

  Future<void> _fakeSubmitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Pesanan berhasil dibuat! (Simulasi)'),
          backgroundColor: Colors.green));
      Navigator.of(context).popUntil((route) => route.isFirst);
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
          onPressed: _isLoading ? null : _fakeSubmitOrder,
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
}
