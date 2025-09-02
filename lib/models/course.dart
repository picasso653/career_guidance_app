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



  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      provider: json['provider'] ?? 'Unknown Provider',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }


    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'provider': provider,
      'url': url,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
    };
  }
  
}