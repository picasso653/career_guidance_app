import 'package:career_guidance_app/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:career_guidance_app/backend/services/recommendation_service.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController interestController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();

  bool _loading = false;

  Future<void> handleSubmit() async {
    if (interestController.text.isEmpty || 
      skillsController.text.isEmpty || 
      goalsController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }
    setState(() => _loading = true);
    try {
      final result = await RecommendationService.getRecommendation(
        interests: interestController.text,
        skills: skillsController.text,
        goals: goalsController.text,
      );
      print("LOL");
      if (!mounted) return;

      // Navigator.pushNamed(context, '/results', arguments: result);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result,)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Career Questionnaire")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                labelText: "Your Interests",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: skillsController,
              decoration: InputDecoration(
                labelText: "Your Skills",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: goalsController,
              decoration: InputDecoration(
                labelText: "Your Career Goals",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleSubmit,
                    child: const Text("Submit Answers"),
                  ),
          ],
        ),
      ),
    );
  }
}
