import 'package:app_laundry/models/laundry_model.dart';
import 'package:app_laundry/screens/laundry_detail_screen.dart';
import 'package:app_laundry/screens/orders_screen.dart';
import 'package:app_laundry/screens/payment_screen.dart';
import 'package:app_laundry/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  // Daftar halaman/widget sesuai urutan di BottomNavigationBar
  // 0: Home, 1: Pesanan, 2: Profil
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenContent(),
    OrdersScreen(), // Ini adalah isi dari tab Home      // Ini adalah halaman Pesanan
    ProfileScreen(), // Ini adalah halaman Profil
  ];

  // Fungsi ini akan dipanggil ketika salah satu tab di-klik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update state untuk mengubah halaman
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body sekarang menampilkan widget dari _widgetOptions sesuai dengan _selectedIndex
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Ini yang menentukan tab mana yang aktif
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped, // Hubungkan aksi tap ke fungsi _onItemTapped
      ),
    );
  }
}

// KODE UNTUK ISI KONTEN HOME (HomeScreenContent) TIDAK PERLU DIUBAH
// Cukup pastikan kode di atas yang Anda gunakan untuk HomeScreen
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // ... (Sisa kode untuk HomeScreenContent tetap sama seperti sebelumnya) ...
  final List<Laundry> allLaundries = [
    Laundry(
        id: '1',
        title: 'Setrika',
        rating: 4.8,
        price: 5000,
        imagePath: 'assets/setrika.jpg',
        description:
            'Pakaian rapi dan wangi dengan setrika uap profesional. Cocok untuk pakaian sehari-hari dan kemeja kerja.'),
    Laundry(
        id: '2',
        title: 'Satuan',
        rating: 4.9,
        price: 8000,
        imagePath: 'assets/Baju contoh.jpg',
        description:
            'Cuci dan setrika per potong pakaian. Penanganan khusus untuk setiap jenis bahan.'),
    Laundry(
        id: '3',
        title: 'Timbangan',
        rating: 4.7,
        price: 7000,
        imagePath: 'assets/timbang.jpg',
        description:
            'Layanan cuci kiloan, solusi hemat untuk cucian menumpuk. Sudah termasuk cuci, kering, dan lipat.'),
    Laundry(
        id: '4',
        title: 'Karpet',
        rating: 4.6,
        price: 10000,
        imagePath: 'assets/Karpet.jpg',
        description:
            'Cuci karpet berbagai ukuran dengan mesin khusus. Menghilangkan debu, tungau, dan noda membandel.'),
    Laundry(
        id: '5',
        title: 'Sepatu',
        rating: 5.0,
        price: 25000,
        imagePath: 'assets/sepatu.jpg',
        description:
            'Deep cleaning untuk semua jenis sepatu (sneakers, kulit, kanvas). Membuat sepatu Anda tampak seperti baru.'),
  ];
  List<Laundry> filteredLaundries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredLaundries = allLaundries;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredLaundries = allLaundries
            .where((l) => l.title.toLowerCase().contains(query))
            .toList();
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
    return Scaffold(
      appBar: AppBar(
        title: _buildCustomAppBar("Budi"),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildPaymentSection(context)),
          ];
        },
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredLaundries.length,
          itemBuilder: (context, index) {
            final laundry = filteredLaundries[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildLaundryCard(context, laundry),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('selamat datang',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
            Text('laundry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari kiloan, setrika, sepatu...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
          ),
        ),
      );

  Widget _buildPaymentSection(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Tagihan Anda',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('Rp 35.000',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2962FF))),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentScreen(totalAmount: 35000))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2962FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Bayar'),
              )
            ],
          ),
        ),
      );

  Widget _buildLaundryCard(BuildContext context, Laundry laundry) =>
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => LaundryDetailScreen(laundry: laundry))),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          shadowColor: Colors.blue.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(laundry.imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(child: Text("Gagal memuat gambar")))),
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
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(laundry.rating.toString(),
                                style: const TextStyle(fontSize: 15)),
                          ]),
                        ],
                      ),
                    ),
                    Text('Rp ${laundry.price}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2962FF))),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
