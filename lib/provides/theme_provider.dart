import 'package:flutter/material.dart';

// Kelas ThemeProvider menggunakan 'with ChangeNotifier'
// agar bisa memberi tahu widget lain ketika datanya (tema) berubah.
class ThemeProvider with ChangeNotifier {
  // Variabel privat untuk menyimpan status mode gelap.
  // Dimulai dengan 'false' (mode terang) secara default.
  bool _isDarkMode = false;

  // Getter publik agar widget lain bisa membaca status saat ini
  // tanpa bisa mengubahnya secara langsung.
  bool get isDarkMode => _isDarkMode;

  // Getter untuk menentukan ThemeMode yang akan digunakan oleh MaterialApp.
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Fungsi untuk mengubah status tema.
  void toggleTheme() {
    // Membalik nilai boolean (jika true menjadi false, jika false menjadi true).
    _isDarkMode = !_isDarkMode;

    // Memberi tahu semua widget yang 'mendengarkan' provider ini
    // bahwa ada perubahan, sehingga mereka bisa membangun ulang (rebuild)
    // dirinya dengan tema yang baru.
    notifyListeners();
  }
}
