import 'package:app_laundry/app_routes.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _fakeRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 139, 174, 240),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2962FF))),
                const SizedBox(height: 20),
                Image.asset('assets/register.png', height: 180),
                const SizedBox(height: 30),
                TextFormField(
                    decoration: _buildInputDecoration(
                        'Nama Lengkap', Icons.person_outline),
                    validator: (v) =>
                        v!.isEmpty ? 'Nama tidak boleh kosong' : null),
                const SizedBox(height: 16),
                TextFormField(
                    decoration:
                        _buildInputDecoration('E-mail', Icons.email_outlined),
                    validator: (v) =>
                        !v!.contains('@') ? 'Email tidak valid' : null),
                const SizedBox(height: 16),
                TextFormField(
                    obscureText: _obscurePassword,
                    decoration:
                        _buildInputDecoration('Password', Icons.lock_outline)
                            .copyWith(
                                suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword))),
                    validator: (v) =>
                        v!.length < 6 ? 'Password minimal 6 karakter' : null),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fakeRegister,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2962FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun? ",
                        style: TextStyle(color: Colors.grey[700])),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(context), // Kembali ke halaman login
                      child: const Text('Masuk',
                          style: TextStyle(
                              color: Color(0xFF2962FF),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF2962FF), width: 2)),
      );
}
