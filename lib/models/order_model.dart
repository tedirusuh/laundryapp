// lib/models/order_model.dart
class Order {
  final int id;
  final String title;
  final String customerName;
  final String status;
  final double price;
  final double weight;
  final String? customerAddress;
  final String? customerWhatsapp;
  final String? paymentMethod;
  final String? notes;

  Order({
    required this.id,
    required this.title,
    required this.customerName,
    required this.status,
    required this.price,
    required this.weight,
    this.customerAddress,
    this.customerWhatsapp,
    this.paymentMethod,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.parse(json['id']),
      title: json['title'],
      customerName: json['customer_name'],
      status: json['status'],
      price: double.parse(json['price']),
      weight: double.parse(json['weight']),
      customerAddress: json['customer_address'],
      customerWhatsapp: json['customer_whatsapp'],
      paymentMethod: json['payment_method'],
      notes: json['notes'],
    );
  }
}
