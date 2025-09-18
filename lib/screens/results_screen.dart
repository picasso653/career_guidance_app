// lib/screens/results_screen.dart
// Add this import at the top
import 'package:flutter/material.dart';
import 'package:career_guidance_app/screens/main_navigation.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? result;
  const ResultScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    arguments ??= result;
    
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('No recommendation data available')),
      );
    }

    final Map<String, dynamic> recommendation = arguments;
    final String educationLevel = recommendation['education_level'] ?? 'Undergraduate';

    try {
      if (educationLevel == "Basic school") {
        // Handle Basic school response
        final String careerPath = recommendation['recommended_career_path']?.toString() ?? 'No career path provided';
        final String highSchoolCourse = recommendation['recommended_high_school_course']?.toString() ?? 'No course recommended';
        final String explanation = recommendation['explanation']?.toString() ?? 'No explanation available';

        return Scaffold(
          appBar: AppBar(
            title: const Text("Career Recommendation"),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recommended Career Path:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Text(careerPath,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 24),

                Text("Recommended High School Course:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Text(highSchoolCourse,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 24),

                Text("Explanation:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(explanation,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              ],
            ),
          ),
        );
      } else if (educationLevel == "High school grad") {
        // Handle High school grad response
        final String careerPath = recommendation['recommended_career_path']?.toString() ?? 'No career path provided';
        final String universityProgram = recommendation['recommended_university_program']?.toString() ?? 'No program recommended';
        final List<String> essentialSkills = (recommendation['essential_skills'] is List)
            ? (recommendation['essential_skills'] as List)
                .map((e) => e.toString())
                .toList()
            : ['No skills listed'];
        final String explanation = recommendation['explanation']?.toString() ?? 'No explanation available';

        return Scaffold(
          appBar: AppBar(
            title: const Text("Career Recommendation"),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recommended Career Path:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Text(careerPath,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 24),

                Text("Recommended University Program:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Text(universityProgram,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 24),

                Text("Essential Skills to Learn:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: essentialSkills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue[50],
                      labelStyle: const TextStyle(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.blue[100]!),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                Text("Explanation:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(explanation,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              ],
            ),
          ),
        );
      } else {
        // Handle Undergraduate response (original format)
        final String job = recommendation['job_title']?.toString() ?? 'No title provided';
        final String description = recommendation['job_description']?.toString() ?? 'No description available';
        final List<String> skills = (recommendation['skills_required'] is List)
            ? (recommendation['skills_required'] as List)
                .map((e) => e.toString())
                .toList()
            : ['No skills listed'];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Career Recommendation"),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recommended Job:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Text(job,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 24),

                Text("Description:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(description,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
                const SizedBox(height: 24),

                Text("Required Skills:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((skill) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainNavigation(
                              initialIndex: 1,
                              initialSubIndex: 0,
                              initialSkill: skill,
                            ),
                          ),
                        );
                      },
                      child: Chip(
                        label: Text(skill),
                        backgroundColor: Colors.blue[50],
                        labelStyle: const TextStyle(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blue[100]!),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainNavigation(
                            initialIndex: 1,
                            initialSubIndex: 1,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Search Available Jobs",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      print('Error displaying results: $e');
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error displaying results'),
              const SizedBox(height: 16),
              Text(e.toString(), style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              Text('Full data: $recommendation',
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }
}