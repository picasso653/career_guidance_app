import 'package:career_guidance_app/providers/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            ? courses
                .where((course) => course.title
                    .toLowerCase()
                    .contains(widget.skill!.toLowerCase()))
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.deepPurple[400]! : Colors.purple[400]!,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                  return Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading courses',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (_displayedCourses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.skill != null
                              ? 'No courses found for "${widget.skill}"'
                              : 'No courses available',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _displayedCourses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final course = _displayedCourses[index];

                    return Consumer<BookmarkProvider>(
                      builder: (context, bookmarkProvider, _) {
                        final isBookmarked =
                            bookmarkProvider.isCourseBookmarked(course.id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(course: course),
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
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return Container(
                                                    color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.broken_image,
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            index < course.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 16,
                                            color: Colors.amber,
                                          );
                                        }),
                                      ),
                                    ),
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
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isBookmarked
                                            ? (isDarkMode ? Colors.deepPurple[200] : Colors.purple[700])
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        bookmarkProvider
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
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}