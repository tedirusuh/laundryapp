// lib/models/laundry_model.dart
class Laundry {
  final String title;
  final double rating;
  final int price;
  final String imagePath;
  final String? distance;

  Laundry({
    required this.title,
    required this.rating,
    required this.price,
    required this.imagePath,
    this.distance,
  });
}
