import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/config.dart';
import '../models/job.dart';
import '../models/course.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? profilePicture;
  final Map<String, dynamic>? testResult;
  final List<Job> bookmarkedJobs;
  final List<Course> bookmarkedCourses;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.profilePicture,
    this.testResult,
    this.bookmarkedJobs = const [],
    this.bookmarkedCourses = const [],
  });
}

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuth => _token != null;
  bool get isLoading => _isLoading;

  /// ✅ Manage loading state in one place
  void setStateLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> signup(String username, String email, String password) async {
    setStateLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Signup failed: ${response.body}');
      }

      await login(username, password);
    } finally {
      setStateLoading(false);
    }
  }

  Future<void> login(String username, String password) async {
    setStateLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Login failed: ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      _token = responseData['access_token'];

      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);

      await _fetchUserProfile();
      notifyListeners();
    } finally {
      setStateLoading(false);
    }
  }

  Future<void> autoLogin() async {
    setStateLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        _token = token;
        await _fetchUserProfile();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Auto-login error: $e');
    } finally {
      setStateLoading(false);
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> _fetchUserProfile() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        final List<Job> bookmarkedJobs = (userData['bookmarked_jobs'] ?? [])
            .map<Job>((jobJson) => Job.fromJson(jobJson))
            .toList();

        final List<Course> bookmarkedCourses =
            (userData['bookmarked_courses'] ?? [])
                .map<Course>((courseJson) => Course.fromJson(courseJson))
                .toList();

        _currentUser = User(
          id: userData['id'].toString(),
          username: userData['username'] ?? '',
          email: userData['email'] ?? '',
          fullName: userData['full_name'],
          profilePicture: userData['profile_picture'],
          testResult: userData['test_result'],
          bookmarkedJobs: bookmarkedJobs,
          bookmarkedCourses: bookmarkedCourses,
        );
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> updateProfile({
    required String username,
    required String email,
    required String fullName,
    File? profileImage,
  }) async {
    if (_token == null) return;
    setStateLoading(true);

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile'),
      );

      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['full_name'] = fullName;

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      if (response.statusCode != 200) {
        throw Exception('Profile update failed');
      }

      await _fetchUserProfile();
      notifyListeners();
    } finally {
      setStateLoading(false);
    }
  }

  Future<void> saveTestResult(Map<String, dynamic> result) async {
    if (_token == null) return;
    setStateLoading(true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/test/test-results'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'interests': result['interests'],
          'skills': result['skills'],
          'goals': result['goals'],
          'recommendation': jsonEncode(result['recommendation']),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save test result');
      }

      await _fetchUserProfile();
      notifyListeners();
    } finally {
      setStateLoading(false);
    }
  }

  Future<void> bookmarkJob(Job job) async {
    if (_token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookmarks/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(job.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to bookmark job');
      }

      await _fetchUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error bookmarking job: $e');
    }
  }

  Future<void> unbookmarkJob(String jobId) async {
    if (_token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/bookmarks/jobs/$jobId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unbookmark job');
      }

      await _fetchUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error unbookmarking job: $e');
    }
  }

  Future<void> bookmarkCourse(Course course) async {
    if (_token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookmarks/courses'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(course.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to bookmark course');
      }

      await _fetchUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error bookmarking course: $e');
    }
  }

  Future<void> unbookmarkCourse(String courseId) async {
    if (_token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/bookmarks/courses/$courseId'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to unbookmark course');
      }

      await _fetchUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error unbookmarking course: $e');
    }
  }
}
