class Course {
  final String id;
  final String title;
  final String provider;
  final String url;
  final String imageUrl;
  final double rating;
  final String description;

  const Course({
    required this.id,
    required this.title,
    required this.provider,
    required this.url,
    required this.imageUrl,
    required this.rating,
    required this.description,
  });
}