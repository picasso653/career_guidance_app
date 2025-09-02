import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';


class AuthService {
  static Future<http.Response> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
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
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    return response;
  }
}
