import 'package:career_guidance_app/backend/services/job_services.dart';
import 'package:career_guidance_app/screens/job_detail_screen.dart';
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
  List<Job> _allJobs = [];
  List<Job> _displayedJobs = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final jobsData = await JobService.fetchJobs();
      setState(() {
        _allJobs = jobsData.map<Job>((job) {
          return Job(
            id: job['url'] ?? UniqueKey().toString(),
            title: job['title'] ?? 'No Title',
            company: job['company'] ?? 'Unknown Company',
            location: job['location'] ?? 'Location not specified',
            source: job['source'] ?? 'Unknown Source',
            description: job['description'] ?? 'No description available',
            applyUrl: job['url'] ?? '',
            logo: job['logo'],
          );
        }).toList();
        
        _displayedJobs = List.from(_allJobs);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load jobs: $e';
      });
    }
  }

  void _filterJobs(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedJobs = List.from(_allJobs);
      } else {
        _displayedJobs = _allJobs.where((job) {
          return job.title.toLowerCase().contains(query.toLowerCase()) ||
                 job.company.toLowerCase().contains(query.toLowerCase()) ||
                 job.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterJobs('');
                      },
                    )
                  : null,
            ),
            onChanged: _filterJobs,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : _displayedJobs.isEmpty
                      ? const Center(child: Text('No jobs found'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _displayedJobs.length,
                          itemBuilder: (context, index) {
                            final job = _displayedJobs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
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
                                leading: job.logo != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(job.logo!),
                                        backgroundColor: Colors.grey[200],
                                      )
                                    : const CircleAvatar(
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
                                        provider.toggleJobBookmark(context, job); // Added context
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
