import 'package:flutter/material.dart';
import '../models/job.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Location: ${job.location}"),
            const SizedBox(height: 10),
            Text("Source: ${job.source}"),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(job.description))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
               
              },
              child: const Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}
