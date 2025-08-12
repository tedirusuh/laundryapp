// lib/order_detail_screen.dart

import 'package:app_laundry/providers/order_provider.dart' as my_order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class OrderDetailScreen extends StatelessWidget {
  final my_order.Order order;
  const OrderDetailScreen({super.key, required this.order});

  // Fungsi untuk update status
  Future<void> _updateOrderStatus(
      BuildContext context, String newStatus) async {
    try {
      // Kirim update ke Firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .update({'status': newStatus});

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status berhasil diubah menjadi "$newStatus"')),
      );
      Navigator.of(context).pop(); // Tutup dialog
      Navigator.of(context).pop(); // Kembali ke halaman daftar pesanan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah status: ${e.toString()}')),
      );
    }
  }

  // Fungsi untuk menampilkan dialog pilihan status (untuk admin)
  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Status Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption(context, 'Sedang Dikerjakan'),
              _buildStatusOption(context, 'Selesai'),
              _buildStatusOption(context, 'Dibatalkan'),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'))
          ],
        );
      },
    );
  }

  // Widget untuk setiap pilihan status di dialog
  Widget _buildStatusOption(BuildContext context, String status) {
    return ListTile(
      title: Text(status),
      onTap: () => _updateOrderStatus(context, status),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format tanggal agar mudah dibaca (misal: Senin, 11 Agustus 2025 09:30)
    final String formattedDate = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID')
        .format(order.createdAt.toDate());

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan #${order.id.substring(0, 6)}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KARTU INFO UTAMA
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetailRow(
                      icon: Icons.local_laundry_service,
                      title: 'Layanan',
                      value: order.title),
                  _buildDetailRow(
                      icon: Icons.label_important_outline,
                      title: 'Status',
                      value: order.status,
                      valueColor: order.status == 'Selesai'
                          ? Colors.green
                          : Colors.orange),
                  _buildDetailRow(
                      icon: Icons.scale_outlined,
                      title: 'Berat/Jumlah',
                      value: '${order.weight} item'),
                  _buildDetailRow(
                      icon: Icons.payment,
                      title: 'Metode Bayar',
                      value: order.paymentMethod),
                  const Divider(height: 20, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rp ${order.price.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // KARTU INFO PELANGGAN
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Info Pelanggan & Waktu',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(thickness: 1),
                  _buildDetailRow(
                      icon: Icons.person_outline,
                      title: 'Nama',
                      value: order.customerName),
                  _buildDetailRow(
                      icon: Icons.home_outlined,
                      title: 'Alamat',
                      value: order.customerAddress),
                  _buildDetailRow(
                      icon: Icons.phone_outlined,
                      title: 'No. WhatsApp',
                      value: order.customerWhatsapp),
                  _buildDetailRow(
                      icon: Icons.event,
                      title: 'Tanggal Pesan',
                      value: formattedDate),
                  if (order.notes.isNotEmpty) ...[
                    const Divider(),
                    _buildDetailRow(
                        icon: Icons.note_alt_outlined,
                        title: 'Catatan',
                        value: order.notes),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
      // Tombol Aksi di bagian bawah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStatusUpdateDialog(context),
        label: const Text('Ubah Status'),
        icon: const Icon(Icons.edit),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Widget helper untuk membuat baris detail yang rapi
  Widget _buildDetailRow(
      {required IconData icon,
      required String title,
      required String value,
      Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade700, size: 20),
          const SizedBox(width: 16),
          Text('$title: ',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontSize: 15),
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
