import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.10.96:8001'; // Use your actual IP on mobile

class AuthService {
  static Future<http.Response> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": email.split('@')[0], // use part before @ as username
        "email": email,
        "password": password,
      }),
    );
    return response;
  }

  static Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    return response;
  }
}
