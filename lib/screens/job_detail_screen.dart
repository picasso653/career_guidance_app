import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/job.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  Future<void> _launchUrl() async {
    if (job.applyUrl.isNotEmpty && await canLaunchUrl(Uri.parse(job.applyUrl))) {
      await launchUrl(Uri.parse(job.applyUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.logo != null && job.logo!.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(job.logo!),
                  backgroundColor: Colors.grey[200],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              job.company,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Location: ${job.location}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Source: ${job.source}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Job Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  job.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launchUrl,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}