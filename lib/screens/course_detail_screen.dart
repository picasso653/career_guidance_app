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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: isDarkMode ? Colors.deepPurple[800] : Colors.purple[200],
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
              ),
              child: course.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        course.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.book,
                        size: 60,
                        color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              course.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provided by ${course.provider}',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
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
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.deepPurple[400] : Colors.purple[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enroll Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You will be redirected to the course provider website to complete enrollment',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}