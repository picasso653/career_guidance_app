import 'package:career_guidance_app/widgets/outlined_button.dart';
import 'package:flutter/material.dart';
import '../widgets/logo_appbar.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final suggestedJob = "Software Engineer";
    final learnedSkills = ["Python", "Flutter", "Git"];
    final testScores = {
      "Python": 80,
      "Flutter": 70,
      "Git": 60,
    };

    return Scaffold(
      appBar: buildLogoAppBar("Your Career Match"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Suggested Career:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                suggestedJob,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              // Job Illustration
              Image.asset(
                'assets/images/software_engineer.png', // Replace with actual image path
                height: 180,
              ),
              const SizedBox(height: 30),
              Text(
                'Your Skills',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: learnedSkills
                    .map((skill) => Chip(label: Text(skill)))
                    .toList(),
              ),
              const SizedBox(height: 30),
              Text(
                'Test Performance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              // Show each skill with a progress bar
              Column(
                children: testScores.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key),
                      LinearProgressIndicator(
                        value: entry.value / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor:
                            // ignore: prefer_const_constructors
                            AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),

              ),
              const SizedBox(height: 20),
              CustomOutlinedButton(text: "get recommendations",
               onPressed: (){
                Navigator.pushReplacementNamed(context, '/recommendations');
               }
               )
            ],
          ),
        ),
      ),
    );
  }
}
