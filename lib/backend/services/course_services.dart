import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';



class CourseService {
  static Future<List<dynamic>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
