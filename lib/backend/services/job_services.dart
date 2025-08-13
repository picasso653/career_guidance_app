import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class JobService {
  static Future<List<dynamic>> fetchJobs() async {
    try {
      // Fetch from both APIs concurrently
      final remotiveFuture = http.get(Uri.parse('$baseUrl/jobs/remotive'));
      final jsearchFuture = http.get(Uri.parse('$baseUrl/jobs/jsearch'));
      
      final responses = await Future.wait([remotiveFuture, jsearchFuture]);
      
      List<dynamic> allJobs = [];
      
      for (final response in responses) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          allJobs.addAll(data['jobs']);
        }
      }
      
      return allJobs;
    } catch (e) {
      throw Exception('Failed to load jobs: $e');
    }
  }
}