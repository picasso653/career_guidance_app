import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';


class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkedJobs = context.watch<BookmarkProvider>().bookmarkedJobs;
    final bookmarkedCourses = context.watch<BookmarkProvider>().bookmarkedCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        centerTitle: true,
      ),
      body: bookmarkedJobs.isEmpty && bookmarkedCourses.isEmpty
          ? const Center(child: Text('No bookmarks yet.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bookmarkedJobs.isNotEmpty) ...[
                    const Text(
                      'Bookmarked Jobs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...bookmarkedJobs.map((job) => ListTile(
                          leading: const Icon(Icons.work),
                          title: Text(job.title),
                          subtitle: Text('${job.company} · ${job.location}'),
                        )),
                  ],
                  if (bookmarkedCourses.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Bookmarked Courses',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...bookmarkedCourses.map((course) => ListTile(
                          leading: const Icon(Icons.school),
                          title: Text(course.title),
                          subtitle: Text(course.title),
                        )),
                  ],
                ],
              ),
            ),
    );
  }
}
