// lib/models/user_model.dart
class User {
  final String fullName;
  final String email;
  final String
      password; // Sebaiknya jangan simpan password di sini di aplikasi nyata

  User({required this.fullName, required this.email, required this.password});
}
