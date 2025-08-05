// lib/providers/order_provider.dart
import 'package:flutter/material.dart';

class Order {
  final String id;
  final String title;
  final String status;
  final double price;

  Order(
      {required this.id,
      required this.title,
      required this.status,
      required this.price});
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  // Modifikasi fungsi ini untuk menerima harga
  void addOrder(String title, double quantity, double pricePerItem) {
    final totalPrice = quantity * pricePerItem;

    final newOrder = Order(
      id: DateTime.now().toString(),
      title:
          '$title (${quantity} ${title == 'Timbangan' ? 'kg' : 'pcs'})', // Sesuaikan satuan
      status: 'Masih Dicuci',
      price: totalPrice,
    );

    _orders.add(newOrder);
    notifyListeners();
  }
}
