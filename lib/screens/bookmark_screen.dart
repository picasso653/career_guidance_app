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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 60,
              color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarked jobs yet',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save interesting jobs to find them here later',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: isDarkMode ? Colors.deepPurple[900] : Colors.purple[50],
          child: ListTile(
            leading: Icon(
              Icons.work,
              color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
            ),
            title: Text(
              job.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              job.company,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.bookmark,
                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
              ),
              onPressed: () {
                Provider.of<BookmarkProvider>(context, listen: false)
                    .toggleJobBookmark(context, job);
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
          ),
        );
      },
    );
  }

  Widget _buildCourseBookmarks(BuildContext context, List<Course> courses) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 60,
              color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarked courses yet',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save interesting courses to find them here later',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: isDarkMode ? Colors.deepPurple[900] : Colors.purple[50],
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: course.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                course.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
                                    child: Center(
                                      child: Icon(
                                        Icons.book,
                                        size: 40,
                                        color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
                              child: Center(
                                child: Icon(
                                  Icons.book,
                                  size: 40,
                                  color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        course.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        course.provider,
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.deepPurple[800] : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                      ),
                      onPressed: () {
                        Provider.of<BookmarkProvider>(context, listen: false)
                            .toggleCourseBookmark(context, course);
                      },
                    ),
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