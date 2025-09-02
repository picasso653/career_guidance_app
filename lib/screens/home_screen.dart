import 'package:career_guidance_app/widgets/news_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skillController = TextEditingController();
    final levelController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Skill Assessment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: skillController,
                decoration: const InputDecoration(
                  labelText: 'Skill(s)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: levelController,
                decoration: const InputDecoration(
                  labelText: 'Skill Level (e.g. Beginner, Intermediate, Expert)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/questionnaire');
                  },
                  child: const Text('Retake Full Assessment'),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Latest News for Your Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const NewsTile(
                title: 'Python Now Most In-Demand Skill in 2025',
                source: 'TechCrunch',
              ),
              const NewsTile(
                title: 'AI Tools That Help Developers Become 10x Faster',
                source: 'Medium',
              ),
              const NewsTile(
                title: 'How to Stay Competitive as a Frontend Dev',
                source: 'The Verge',
              ),
              // You can replace the above with a ListView.builder in the future
            ],
          ),
        ),
      ),
    );
  }
}