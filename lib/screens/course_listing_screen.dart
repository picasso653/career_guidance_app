import 'package:flutter/material.dart';
import '../backend/services/course_services.dart';

class CourseListingScreen extends StatefulWidget {
  final String? skill;
  const CourseListingScreen({super.key, this.skill});

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  late Future<List<dynamic>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = CourseService.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.skill != null ? 'Courses for ${widget.skill}' : 'Top Courses'),
      // ),
      body: FutureBuilder<List<dynamic>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allCourses = snapshot.data!;
          // Optional filtering
          final filtered = widget.skill != null
              ? allCourses.where((course) =>
                  (course['title'] as String)
                      .toLowerCase()
                      .contains(widget.skill!.toLowerCase()))
                  .toList()
              : allCourses;

          if (filtered.isEmpty) {
            return Center(child: Text('No courses found for "${widget.skill}"'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final course = filtered[index];
              return GestureDetector(
                onTap: () {
                  // navigate to a detail screen if you want
                },
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(course['imageUrl'], height: 100, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(course['provider']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
