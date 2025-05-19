class UserProfile {
  final String courseOfStudy;
  final List<String> skills;
  final String currentLevel;
  final String educationalLevel;

  UserProfile({
    required this.courseOfStudy,
    required this.skills,
    required this.currentLevel,
    required this.educationalLevel,
  });

  Map<String, dynamic> toJson() => {
        'courseOfStudy': courseOfStudy,
        'skills': skills,
        'currentLevel': currentLevel,
        'educationalLevel': educationalLevel,
      };
}
