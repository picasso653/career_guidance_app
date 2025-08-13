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
}
