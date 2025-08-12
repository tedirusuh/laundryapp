// 'cloud_firestore' diimpor karena kita menggunakan tipe data 'Timestamp'
// untuk data contoh (static data) di file lain. Ini mencegah error.

class Order {
  // Properti atau field yang dimiliki oleh setiap pesanan
  final String id;
  final String title;
  final String customerName;
  final String status;
  final double price;
  final String customerAddress;
  final String customerWhatsapp;
  final String paymentMethod;
  final String notes;
  final double weight;

  // Constructor: Ini adalah fungsi yang dipanggil saat kita membuat objek Order baru.
  // 'required' berarti setiap properti ini wajib diisi.
  Order({
    required this.id,
    required this.title,
    required this.customerName,
    required this.status,
    required this.price,
    required this.customerAddress,
    required this.customerWhatsapp,
    required this.paymentMethod,
    required this.notes,
    required this.weight,
  });
}
