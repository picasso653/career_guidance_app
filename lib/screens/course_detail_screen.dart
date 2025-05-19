import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(course.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Provided by ${course.provider}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < course.rating ? Icons.star : Icons.star_border,
                        size: 20,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(course.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
