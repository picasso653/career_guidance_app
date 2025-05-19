class Course {
  final String id;
  final String title;
  final String provider;
  final double rating;
  final String imageUrl;
  final String description;
  bool isBookmarked;

  Course({
    required this.id,
    required this.title,
    required this.provider,
    required this.rating,
    required this.imageUrl,
    required this.description,
    this.isBookmarked = false,
  });
}
