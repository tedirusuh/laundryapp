// lib/home_screen.dart

import 'package:app_laundry/laundry_detail_screen.dart';
import 'package:app_laundry/models/laundry_model.dart';
import 'package:app_laundry/orders_screen.dart';
import 'package:app_laundry/payment_screen.dart';
import 'package:app_laundry/profile_screen.dart';
import 'package:app_laundry/providers/order_provider.dart' as my_order;
import 'package:app_laundry/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  // Constructor sudah benar, tidak perlu menerima data user lagi
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman utama
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenContent(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget terpisah untuk isi konten Halaman Beranda
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Consumer untuk mengambil data dari UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Tampilkan loading jika data user belum siap
        if (userProvider.user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        // Ambil nama pengguna dari provider
        final userName = userProvider.user!.fullName;

        return SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(userName),
              _buildSearchBar(),
              _buildPaymentSection(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('services')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Terjadi kesalahan memuat data.'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada layanan tersedia.'));
                    }

                    final laundryDocs = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title =
                          (data['title'] ?? '').toString().toLowerCase();
                      return title.contains(_searchQuery);
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: laundryDocs.length,
                      itemBuilder: (context, index) {
                        final doc = laundryDocs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        final laundry = Laundry(
                          id: doc.id,
                          title: data['title'] ?? '',
                          rating: (data['rating'] ?? 0.0).toDouble(),
                          price: (data['price'] ?? 0).toInt(),
                          imagePath: _getAssetPath(data['title'] ?? ''),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildLaundryCard(context, laundry),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getAssetPath(String title) {
    switch (title.toLowerCase()) {
      case "setrika":
        return 'assets/setrika.jpg';
      case "satuan":
        return 'assets/Baju contoh.jpg';
      case "timbangan":
        return 'assets/timbang.jpg';
      case "karpet":
        return 'assets/Karpet.jpg';
      case "sepatu":
        return 'assets/sepatu.jpg';
      default:
        return 'assets/setrika.jpg'; // Gambar default
    }
  }

  Widget _buildPaymentSection() {
    return Consumer<my_order.OrderProvider>(
      builder: (context, orderProvider, child) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Tagihan Anda',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                        'Rp. ${orderProvider.totalUnpaidAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Hanya izinkan bayar jika ada tagihan
                    if (orderProvider.totalUnpaidAmount > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                              totalAmount: orderProvider.totalUnpaidAmount),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Bayar',
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Home',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Selamat datang, $name!',
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari kiloan, setrika, sepatu...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLaundryCard(BuildContext context, Laundry laundry) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaundryDetailScreen(laundry: laundry),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              laundry.imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(laundry.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(laundry.rating.toString()),
                        ]),
                      ],
                    ),
                  ),
                  Text('Rp. ${laundry.price}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
