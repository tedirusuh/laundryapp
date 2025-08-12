// lib/payment_screen.dart

import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  // FUNGSI INI DIPERBAIKI
  Future<void> _processPayment(String methodName) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Memproses pembayaran via $methodName...")),
    );

    // Simulasi proses pembayaran
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Panggil fungsi BARU yang sudah kita perbaiki
      await Provider.of<OrderProvider>(context, listen: false)
          .markFinishedOrdersAsPaid();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pembayaran Berhasil! Terima kasih."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Kembali ke halaman beranda
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Total Tagihan',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      'Rp. ${widget.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPaymentMethodButton(
                title: 'DANA', onPressed: () => _processPayment('DANA')),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
                title: 'GoPay', onPressed: () => _processPayment('GoPay')),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
                title: 'Transfer Bank',
                onPressed: () => _processPayment('Transfer Bank')),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(
      {required String title, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(title, style: const TextStyle(fontSize: 16)),
    );
  }
}
