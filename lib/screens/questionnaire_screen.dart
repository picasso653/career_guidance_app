// lib/screens/questionnaire_screen.dart
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
  
  String? _selectedLevel = 'Undergraduate';
  final List<String> _educationLevels = ['Basic school', 'High school grad', 'Undergraduate'];
  
  bool _loading = false;

  void _updateFieldStates() {
    setState(() {
      if (_selectedLevel == 'Basic school') {
        skillsController.clear();
        goalsController.clear();
      } else if (_selectedLevel == 'High school grad') {
        skillsController.clear();
      }
    });
  }

  Future<void> handleSubmit() async {
    if (interestController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill interests field')),
      );
      return;
    }
    
    if (_selectedLevel == 'Undergraduate' && 
        (skillsController.text.isEmpty || goalsController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    
    if (_selectedLevel == 'High school grad' && goalsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill career goals field')),
      );
      return;
    }
    
    setState(() => _loading = true);
    try {
      final result = await RecommendationService.getRecommendation(
        interests: interestController.text,
        skills: skillsController.text,
        goals: goalsController.text,
        educationLevel: _selectedLevel!,
      );
      
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result)));
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
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: InputDecoration(
                labelText: "Education Level",
                border: borderStyle,
              ),
              items: _educationLevels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLevel = newValue;
                  _updateFieldStates();
                });
              },
            ),
            const SizedBox(height: 12),
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
              enabled: _selectedLevel == 'Undergraduate',
              decoration: InputDecoration(
                labelText: "Your Skills",
                border: borderStyle,
                hintText: _selectedLevel != 'Undergraduate' 
                  ? 'Disabled for selected education level' 
                  : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: goalsController,
              enabled: _selectedLevel != 'Basic school',
              decoration: InputDecoration(
                labelText: "Your Career Goals",
                border: borderStyle,
                hintText: _selectedLevel == 'Basic school' 
                  ? 'Disabled for basic school level' 
                  : null,
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