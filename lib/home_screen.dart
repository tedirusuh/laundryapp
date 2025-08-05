// lib/screens/home_screen.dart

import 'package:app_laundry/laundry_detail_screen.dart';
import 'package:app_laundry/models/laundry_model.dart';
import 'package:app_laundry/models/user_model.dart';
import 'package:app_laundry/orders_screen.dart';
import 'package:app_laundry/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  // Daftar data laundry (bisa Anda tambahkan di sini)
  final List<Laundry> laundryList = [
    Laundry(
      title: 'kiloan',
      rating: 5,
      price: 7000,
      imagePath: 'assets/tmbangan2.jpg',
    ),
    Laundry(
      title: 'sepatu',
      rating: 4.5,
      price: 30000,
      distance: '1.1 km',
      imagePath: 'assets/sepatu.jpg',
    ),
    Laundry(
      title: 'setrika',
      rating: 4.8,
      price: 5000,
      distance: '1.5 km',
      imagePath: 'assets/setrika.jpg',
    ),
    Laundry(
      title: 'laundry',
      rating: 4.8,
      price: 5000,
      distance: '1.5 km',
      imagePath: 'assets/2.jpg',
    ),
    Laundry(
      title: 'satuan',
      rating: 4.8,
      price: 8000,
      distance: '1.5 km',
      imagePath: 'assets/Baju contoh.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreenContent(
          userName: widget.user.fullName, laundryList: laundryList),
      const OrdersScreen(),
      ProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F0FF),
      body: _widgetOptions.elementAt(_selectedIndex),
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
        backgroundColor: Colors.white,
      ),
    );
  }
}

// --- PERUBAHAN UTAMA DIMULAI DARI SINI ---

// 1. Ubah HomeScreenContent menjadi StatefulWidget
class HomeScreenContent extends StatefulWidget {
  final String userName;
  final List<Laundry> laundryList;

  const HomeScreenContent(
      {super.key, required this.userName, required this.laundryList});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // 2. Tambahkan state untuk logika pencarian
  late List<Laundry> _filteredLaundryList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredLaundryList = widget.laundryList;
    _searchController.addListener(_filterLaundry);
  }

  void _filterLaundry() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLaundryList = widget.laundryList.where((laundry) {
        return laundry.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLaundry);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // 3. Panggil AppBar dengan Lonceng
          _buildCustomAppBar(widget.userName),

          // 4. Panggil Search Bar
          _buildSearchBar(),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // 5. Tampilkan daftar yang sudah difilter
              itemCount: _filteredLaundryList.length,
              itemBuilder: (context, index) {
                final laundry = _filteredLaundryList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildLaundryCard(context, laundry),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget AppBar dengan Lonceng Notifikasi
  Widget _buildCustomAppBar(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('Home',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down)
              ]),
              SizedBox(height: 4),
              Text('Block no.23,Saigaon,0043',
                  style: TextStyle(color: Colors.black54)),
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
              onPressed: () {
                // Aksi saat lonceng notifikasi di-klik
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Search Bar Baru
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

  // Widget kartu laundry (tidak berubah)
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
        shadowColor: Colors.blue.withOpacity(0.2),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (laundry.distance != null)
                          Row(children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(laundry.distance!,
                                style: TextStyle(color: Colors.grey[600]))
                          ]),
                        const SizedBox(height: 2),
                        Text(laundry.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(laundry.rating.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('mulai dari', style: TextStyle(fontSize: 12)),
                      Text(
                        'Rp. ${laundry.price}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
