import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../models/course.dart';
import '../providers/auth_provider.dart';

class BookmarkProvider with ChangeNotifier {
  List<Job> _bookmarkedJobs = [];
  List<Course> _bookmarkedCourses = [];

  List<Job> get bookmarkedJobs => _bookmarkedJobs;
  List<Course> get bookmarkedCourses => _bookmarkedCourses;

  BookmarkProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load jobs
    final jobsJson = prefs.getStringList('bookmarkedJobs') ?? [];
    _bookmarkedJobs = jobsJson
        .map((json) => Job.fromJson(jsonDecode(json)))
        .toList();
    
    // Load courses
    final coursesJson = prefs.getStringList('bookmarkedCourses') ?? [];
    _bookmarkedCourses = coursesJson
        .map((json) => Course.fromJson(jsonDecode(json)))
        .toList();
    
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save jobs
    final jobsJson = _bookmarkedJobs
        .map((job) => jsonEncode(job.toJson()))
        .toList();
    await prefs.setStringList('bookmarkedJobs', jobsJson);
    
    // Save courses
    final coursesJson = _bookmarkedCourses
        .map((course) => jsonEncode(course.toJson()))
        .toList();
    await prefs.setStringList('bookmarkedCourses', coursesJson);
  }

  void toggleJobBookmark(BuildContext context, Job job) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuth) {
      // Use backend for authenticated users
      if (isJobBookmarked(job.id)) {
        authProvider.unbookmarkJob(job.id);
      } else {
        authProvider.bookmarkJob(job);
      }
    } else {
      // Use local storage for guests - REMOVED SETSTATE
      if (isJobBookmarked(job.id)) {
        _bookmarkedJobs.removeWhere((j) => j.id == job.id);
      } else {
        _bookmarkedJobs.add(job);
      }
      _saveBookmarks();
      notifyListeners();
    }
  }

  void toggleCourseBookmark(BuildContext context, Course course) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuth) {
      // Use backend for authenticated users
      if (isCourseBookmarked(course.id)) {
        authProvider.unbookmarkCourse(course.id);
      } else {
        authProvider.bookmarkCourse(course);
      }
    } else {
      // Use local storage for guests - REMOVED SETSTATE
      if (isCourseBookmarked(course.id)) {
        _bookmarkedCourses.removeWhere((c) => c.id == course.id);
      } else {
        _bookmarkedCourses.add(course);
      }
      _saveBookmarks();
      notifyListeners();
    }
  }

  bool isJobBookmarked(String jobId) {
    return _bookmarkedJobs.any((job) => job.id == jobId);
  }

  bool isCourseBookmarked(String courseId) {
    return _bookmarkedCourses.any((course) => course.id == courseId);
  }
}