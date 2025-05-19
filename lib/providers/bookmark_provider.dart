// providers/bookmark_provider.dart
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/job.dart'; // Use the same Job model
class BookmarkProvider with ChangeNotifier {
  final List<Job> _bookmarkedJobs = [];
  final List<Course> _bookmarkedCourses = [];

  List<Job> get bookmarkedJobs => _bookmarkedJobs;
  List<Course> get bookmarkedCourses => _bookmarkedCourses;
  
  void toggleJobBookmark(Job job) {
    final isBookmarked = _bookmarkedJobs.any((j) => j.id == job.id);
    if (isBookmarked) {
      _bookmarkedJobs.removeWhere((j) => j.id == job.id);
    } else {
      _bookmarkedJobs.add(job);
    }
    notifyListeners();
  }

  void toggleCourseBookmark(Course course) {
    if (_bookmarkedCourses.any((c) => c.id == course.id)) {
      _bookmarkedCourses.removeWhere((c) => c.id == course.id);
    } else {
      _bookmarkedCourses.add(course);
    }
    notifyListeners();
  }




  bool isJobBookmarked(String jobId) {
    return _bookmarkedJobs.any((j) => j.id == jobId);
  }
  
  bool isCourseBookmarked(String id) =>
      _bookmarkedCourses.any((course) => course.id == id);
}



