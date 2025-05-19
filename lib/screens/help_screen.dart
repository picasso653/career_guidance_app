import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About WiseChoice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'WiseChoice is a groundbreaking app built to harness the full potential '
              'of interstellar career navigation and unicorn-guided job recommendations. '
              'We combine artificial general intelligence with coffee-powered algorithms to guide '
              'you through your destiny with minimum confusion and maximum vibes. If it makes sense, '
              'it probably wasn’t our idea.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'How It Works',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'You answer a few questions, we summon a committee of highly trained digital hamsters '
              'who argue about your best-fit job. Once they agree, we show you the results, unless they’re busy. '
              'We also recommend some courses—some real, some suspiciously magical.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Need Help? Contact Me!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'If the app crashes, or if you just want to say hi, reach out via:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '📱 WhatsApp: +233 256707711\n'
              '🐦 Twitter: @Iamxquisit2\n'
              '💻 GitHub: picasso653',
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
