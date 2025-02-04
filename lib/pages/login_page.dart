// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); //super parameters

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // FormKey validasi

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? _errorMessage;

  // ================================================Login Function ======================================================
  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();

        final String? result = await context.read<AuthenticationService>().signIn(
              email: email,
              password: password,
            );
        if (result != null) {
          setState(() {
            _errorMessage = result;
          });
        } else {
          // Ambil role dari SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final role = prefs.getString('role') ?? 'operator';

          // Navigasi ke halaman utama berdasarkan role
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } catch (e) {
        // Tangani error lainnya
        setState(() {
          _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ================================================Building The Screen ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      resizeToAvoidBottomInset: true, // Menghindari overflow saat keyboard muncul
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              // Top Image
              Image.asset(
                'assets/images/logoo.png', 
                height: 280,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Login Text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Form
              _buildLoginForm(),
              const SizedBox(height: 20),
              // Tampilkan pesan error
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.indigo, 
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================Login Form Widget ==============================================
  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email TextField
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email, color: Colors.indigo),
              labelText: 'Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                return 'Masukkan email yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Password TextField
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock, color: Colors.indigo),
              labelText: 'Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.indigo,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password tidak boleh kosong';
              }
              if (value.trim().length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
