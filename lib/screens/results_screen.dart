import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? result;
  const ResultScreen({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    arguments ??= result;
    // Debug print to see what we're receiving
    print('Received arguments: $arguments');

    // Handle case where arguments is null or not a Map
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('No recommendation data available')),
      );
    }

    // Directly use arguments as the recommendation object
    final Map<String, dynamic> recommendation = arguments;

    try {
      // Get values with fallbacks
      final String job = recommendation['job_title']?.toString() ?? 'No title provided';
      final String description = recommendation['job_description']?.toString() ?? 'No description available';
      final List<String> skills = (recommendation['skills_required'] is List)
          ? (recommendation['skills_required'] as List).map((e) => e.toString()).toList()
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
              // Recommended Job Section
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
              
              // Description Section
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
              
              // Skills Section
              Text("Required Skills:", 
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Colors.blue[50],
                  labelStyle: const TextStyle(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blue[100]!),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // Error handling with debug information
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
              Text('Full data: $arguments', 
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }
  }
}