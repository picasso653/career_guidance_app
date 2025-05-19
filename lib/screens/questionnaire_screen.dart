import 'package:flutter/material.dart';
import '../widgets/logo_appbar.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black38),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      appBar: buildLogoAppBar("Questions"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Answer the following to help us match your Python skill level:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text("Q1: How do you declare a list in Python?"),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "e.g., my_list = [1, 2, 3]",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 24),
            const Text("Q2: What does the 'len()' function do in Python?"),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "e.g., It returns the length of a string or list",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 24),
            const Text("Q3: What is the difference between a list and a tuple?"),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "e.g., Lists are mutable, tuples are not",
                border: borderStyle,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/results');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black38),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Submit Answers"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
