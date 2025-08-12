import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  static Future<Map<String, dynamic>> getRecommendation({
    required String interests,
    required String skills,
    required String goals,
  }) async {
    final url = Uri.parse("http://10.0.2.2:8000/recommend"); // Use your IP or localhost
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'interests': interests,
        'skills': skills,
        'goals': goals,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['recommendation'] as Map<String, dynamic>;
    } else {
      throw Exception("Failed to get recommendation");
    }
  }
}
