class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String source;
  final String description;
  final String applyUrl;
  final String? logo;

  bool isBookmarked;


  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.source,
    required this.description,
    required this.applyUrl,
    this.logo,
    this.isBookmarked = false,
  });


  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      company: json['company'] ?? 'Unknown Company',
      location: json['location'] ?? 'Location not specified',
      source: json['source'] ?? 'Unknown Source',
      description: json['description'] ?? 'No description available',
      applyUrl: json['applyUrl'] ?? '',
      logo: json['logo'],
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Object? toJson() {
    return null;
  }
}



