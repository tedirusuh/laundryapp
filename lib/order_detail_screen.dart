// lib/laundry_detail_screen.dart
import 'package:app_laundry/models/laundry_model.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/utils/launch_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LaundryDetailScreen extends StatelessWidget {
  // PASTIKAN BAGIAN INI ADA: Kode ini membuat halaman siap menerima data 'laundry'
  final Laundry laundry;
  const LaundryDetailScreen({super.key, required this.laundry});

  @override
  Widget build(BuildContext context) {
    const String laundryPhoneNumber =
        '6281234567890'; // GANTI DENGAN NOMOR WA ANDA
    const String laundryName = 'Laundry Express';

    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      appBar: AppBar(
        title: Text(laundry.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset(
                        laundry.imagePath,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 220,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 60),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Dengan tenaga yang berpengalaman, kami siap melayani kebutuhan laundry Anda.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Daftar Harga',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildPriceItem('Cuci Kiloan', 'Rp. 7.000/kg'),
                    _buildPriceItem('Setrika', 'Rp. 5.000/kg'),
                    _buildPriceItem('Dry Cleaning Jas', 'Rp. 30.000/pcs'),
                    _buildPriceItem('Karpet', 'Rp. 20.000/m²'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final String message =
                      'Halo $laundryName, saya ingin memesan layanan ${laundry.title}.';
                  launchWhatsApp(phone: laundryPhoneNumber, message: message);
                },
                icon: const FaIcon(FontAwesomeIcons.whatsapp,
                    color: Colors.white),
                label: const Text(
                  'Pesan via WhatsApp',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _buildPriceItem(String service, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(service, style: const TextStyle(fontSize: 16)),
          Text(price,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
