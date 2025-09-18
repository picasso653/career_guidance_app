import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class RecommendationService {
  static Future<Map<String, dynamic>> getRecommendation({
    required String interests,
    required String skills,
    required String goals,
    required String educationLevel,
  }) async {
    try {
      // Debug print input
      print('Sending recommendation request with:');
      print('Interests: $interests');
      print('Skills: $skills');
      print('Goals: $goals');
      print('educational level: $educationLevel');

      final response = await http.post(
        Uri.parse('$baseUrl/recommend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "interests": interests,
          "skills": skills,
          "goals": goals,
          'education_level': educationLevel,
        }),
      ).timeout(const Duration(seconds: 30));

      // Debug print response
      print('Received response:');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }
        
        if (jsonResponse.containsKey('recommendation')) {
          final recommendation = jsonResponse['recommendation'];
          
          // Validate recommendation structure
          if (recommendation is Map<String, dynamic> &&
              recommendation.containsKey('job_title') &&
              recommendation.containsKey('job_description') &&
              recommendation.containsKey('skills_required')) {
            return recommendation;
          } else {
            throw Exception('Invalid recommendation structure');
          }
        } else {
          throw Exception('Missing recommendation field in response');
        }
      } else {
        throw Exception('Request failed with status ${response.statusCode}: ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } 
    // on TimeoutException catch (_) {
    //   throw Exception('Request timed out');
    // }
     catch (e) {
      throw Exception('Failed to get recommendation: $e');
    }
  }
}