import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../models/job.dart';
import '../models/course.dart';
import 'job_detail_screen.dart';
import 'course_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.work), text: 'Jobs'),
              Tab(icon: Icon(Icons.school), text: 'Courses'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Jobs Tab
            _buildJobBookmarks(context, bookmarkProvider.bookmarkedJobs),
            
            // Courses Tab
            _buildCourseBookmarks(context, bookmarkProvider.bookmarkedCourses),
          ],
        ),
      ),
    );
  }

  Widget _buildJobBookmarks(BuildContext context, List<Job> jobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text('No bookmarked jobs'));
    }
    
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return ListTile(
          leading: const Icon(Icons.work),
          title: Text(job.title),
          subtitle: Text(job.company),
          trailing: IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.blue),
            onPressed: () {
              Provider.of<BookmarkProvider>(context, listen: false)
                  .toggleJobBookmark(context, job); // Added context
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetailScreen(job: job),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCourseBookmarks(BuildContext context, List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('No bookmarked courses'));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
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
            child: Stack(
              children: [
                Column(
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
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark, color: Colors.blue),
                    onPressed: () {
                      Provider.of<BookmarkProvider>(context, listen: false)
                          .toggleCourseBookmark(context, course); // Added context
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
