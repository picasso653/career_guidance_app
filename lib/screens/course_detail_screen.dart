import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  Future<void> _launchUrl() async {
    if (await canLaunchUrl(Uri.parse(course.url))) {
      await launchUrl(Uri.parse(course.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            course.imageUrl.isNotEmpty
                ? Image.network(
  course.imageUrl,
  height: 200,
  width: double.infinity,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image)),
    );
  },
)
                : Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.book, size: 100)),
                  ),
            const SizedBox(height: 20),
            Text(
              course.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Provided by ${course.provider}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < course.rating ? Icons.star : Icons.star_border,
                    size: 24,
                    color: Colors.amber,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  course.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Enroll Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}