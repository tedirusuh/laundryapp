// lib/payment_screen.dart
import 'package:app_laundry/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  Future<void> _processPayment(String methodName) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Memproses pembayaran dengan $methodName...")),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (methodName == 'DANA' || methodName == 'GoPay') {
      final Uri paymentUrl = Uri.parse(
          'https://example.com/api/payment/$methodName?amount=${widget.totalAmount}');

      try {
        if (await canLaunchUrl(paymentUrl)) {
          await launchUrl(paymentUrl, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $methodName app.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    } else {
      await Provider.of<OrderProvider>(context, listen: false)
          .markAllOrdersAsPaid();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Pembayaran via $methodName Berhasil! Semua tagihan lunas."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
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
                    const Text(
                      'Total Tagihan',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp. ${widget.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodButton(
              title: 'DANA',
              icon: Icons.account_balance_wallet,
              onPressed: () => _processPayment('DANA'),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
              title: 'GoPay',
              icon: Icons.wallet_giftcard,
              onPressed: () => _processPayment('GoPay'),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
              title: 'Transfer BRI',
              icon: Icons.food_bank,
              onPressed: () => _processPayment('Transfer BRI'),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
              title: 'Transfer Mandiri',
              icon: Icons.food_bank,
              onPressed: () => _processPayment('Transfer Mandiri'),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodButton(
              title: 'Transfer BNI',
              icon: Icons.food_bank,
              onPressed: () => _processPayment('Transfer BNI'),
            ),
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

  Widget _buildPaymentMethodButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
