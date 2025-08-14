

import 'package:flutter/material.dart';
import '../backend/services/course_services.dart';
import '../models/course.dart';
import 'course_detail_screen.dart';

class CourseListingScreen extends StatefulWidget {
  final String? skill;
  const CourseListingScreen({super.key, this.skill});

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  late Future<List<Course>> _coursesFuture;
  List<Course> _allCourses = [];
  List<Course> _displayedCourses = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      final coursesData = await CourseService.fetchCourses();
      final courses = coursesData.map<Course>((course) {
        return Course(
          id: course['id'] ?? '',
          title: course['title'] ?? 'No Title',
          provider: course['provider'] ?? 'Unknown Provider',
          url: course['url'] ?? '',
          imageUrl: course['imageUrl'] ?? '',
          rating: (course['rating'] ?? 0.0).toDouble(),
          description: course['description'] ?? '',
        );
      }).toList();
      
      setState(() {
        _allCourses = courses;
        _displayedCourses = widget.skill != null
            ? courses.where((course) => 
                  course.title.toLowerCase().contains(widget.skill!.toLowerCase()))
                .toList()
            : courses;
      });
      
      return courses;
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  void _filterCourses(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedCourses = List.from(_allCourses);
      } else {
        _displayedCourses = _allCourses.where((course) {
          return course.title.toLowerCase().contains(query.toLowerCase()) ||
                 course.provider.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterCourses('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterCourses,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (_displayedCourses.isEmpty) {
                  return Center(child: Text(
                    widget.skill != null 
                      ? 'No courses found for "${widget.skill}"'
                      : 'No courses available'
                  ));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _displayedCourses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final course = _displayedCourses[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailScreen(course: course),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: course.imageUrl.isNotEmpty
                                  ? Image.network(
                                      course.imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: const Center(child: Icon(Icons.book)),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                course.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                course.provider,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < course.rating ? Icons.star : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
