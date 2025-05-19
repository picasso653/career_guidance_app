import 'package:flutter/material.dart';
import '../widgets/logo_appbar.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key});

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  final _skillsController = TextEditingController();
  String _level = '100';
  String _educationLevel = 'Undergraduate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildLogoAppBar("Your Info"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course of Study'),
              ),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                    labelText: 'Skills (comma-separated)'),
              ),
              DropdownButtonFormField(
                value: _level,
                items: ['100', '200', '300', '400']
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text("Level $e")))
                    .toList(),
                onChanged: (val) => setState(() => _level = val!),
                decoration: const InputDecoration(labelText: 'Current Level'),
              ),
              DropdownButtonFormField(
                value: _educationLevel,
                items: ['Undergraduate', 'Diploma', 'SHS', 'Graduate']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _educationLevel = val!),
                decoration:
                    const InputDecoration(labelText: 'Educational Level'),
              ),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Later: Save data or pass to next screen
                      Navigator.pushNamed(context, '/questionnaire');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black38),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Continue to Questions"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Center(
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/results');
//                 },
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.black87,
//                   backgroundColor: Colors.white,
//                   side: const BorderSide(color: Colors.black38),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text("Submit Answers"),
//               ),
//             ),