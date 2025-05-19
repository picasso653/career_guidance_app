import 'package:career_guidance_app/models/job_detail_screen.dart';
import 'package:career_guidance_app/providers/bookmark_provider.dart';
import 'package:flutter/material.dart';
import '../models/job.dart';
import 'package:provider/provider.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  List<Job> jobList = List.generate(
    10,
    (index) => Job(
      id: "111",
      title: 'UI/UX Intern',
      company: 'EXE Services',
      location: 'India · Remote',
      source: 'LinkedIn',
      description: 'Full job description goes here for UI/UX intern.',
      applyUrl: 'https://example.com/apply',
    ),
  );

  void toggleBookmark(int index) {
    setState(() {
      jobList[index].isBookmarked = !jobList[index].isBookmarked;
    });
    // Optionally: Add to a global bookmark list here.
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobList.length,
      itemBuilder: (context, index) {
        final job = jobList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(job: job),
                ),
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.work, color: Colors.white),
            ),
            title: Text(job.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${job.company} · ${job.location}'),
                const Text('45 minutes ago · Easy Apply'),
              ],
            ),
            trailing: Consumer<BookmarkProvider>(
              builder: (context, provider, _) {
                final isBookmarked = provider.isJobBookmarked(job.id);
                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.grey : null,
                  ),
                  onPressed: () {
                    provider.toggleJobBookmark(job);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
