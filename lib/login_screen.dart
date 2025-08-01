// lib/login_screen.dart
import 'package:flutter/material.dart';
// import 'home_screen.dart'; // Impor halaman utama

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _nameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  String? _nameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;

  void _validateAndLogin() {
    setState(() {
      _nameError = _nameController.text.isEmpty;
      _emailError =
          _emailController.text.isEmpty || !_emailController.text.contains('@');
      _passwordError = _passwordController.text.isEmpty ||
          _passwordController.text.length < 3;
      _nameErrorText = _nameError ? 'Name is required' : null;
      _emailErrorText = _emailError ? 'Valid email is required' : null;
      _passwordErrorText = _passwordError ? 'Password min 3 karakter' : null;
    });
    if (!_nameError && !_emailError && !_passwordError) {
      // TODO: Proses login
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2962FF);
    const Color lightBlueBg = Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 139, 174, 240),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/login.png', height: 180),
              const SizedBox(height: 30),
              _buildTextField(
                label: 'Name',
                icon: Icons.person_outline,
                controller: _nameController,
                error: _nameError,
              ),
              if (_nameErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_nameErrorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'E-mail',
                icon: Icons.email_outlined,
                controller: _emailController,
                error: _emailError,
              ),
              if (_emailErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_emailErrorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
                error: _passwordError,
              ),
              if (_passwordErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_passwordErrorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('Log in',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('or',
                  style: TextStyle(
                      color: primaryBlue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(color: Colors.grey[700])),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Sign up',
                        style: TextStyle(
                            color: primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
    bool error = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: error ? Colors.red : Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: error ? Colors.red : Color(0xFF2962FF)),
        ),
      ),
    );
  }
}
