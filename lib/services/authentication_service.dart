import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final String baseUrl = 'http://172.20.10.2/conveyor_app/'; 

  // Metode untuk login
  Future<String?> signIn({required String email, required String password}) async {
    final url = Uri.parse('${baseUrl}login.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['message'] == 'Login berhasil') {
        // Simpan email, username, dan role ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('username', data['username'] ?? 'Tidak Tersedia');
        await prefs.setString('role', data['role'] ?? 'operator'); 

        return null; // Login berhasil
      } else {
        return data['message']; // Pesan error 
      }
    } else {
      return 'Server error: ${response.statusCode}'; // Pesan error 
    }
  }

  // Metode untuk logout
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data yang disimpan
  }
}
