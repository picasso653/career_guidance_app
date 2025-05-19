import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class CourseListingScreen extends StatelessWidget {
  const CourseListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = [
      Course(
        id: '111',
        title: 'Flutter Development',
        provider: 'Udemy',
        rating: 4.5,
        imageUrl: 'https://placehold.co/200x120',
        description: 'Learn to build beautiful mobile apps using Flutter.',
      ),
      Course(
        id: '234',
        title: 'Python for Data Science',
        provider: 'Coursera',
        rating: 4.8,
        imageUrl: 'https://placehold.co/200x120',
        description: 'Master data analysis with Python and real-world projects.',
      ),
      // Add more mock courses as needed
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Top Courses')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return CourseCard(
              course: courses[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(course: courses[index]),
                  ),
                );
              },
              
            );
          },
        ),
      ),
    );
  }
}
