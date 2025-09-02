import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      _usernameController.text = user.username;
      _nameController.text = user.fullName ?? '';
      _emailController.text = user.email;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateProfile(
      username: _usernameController.text,
      email: _emailController.text,
      fullName: _nameController.text,
      profileImage: _profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        actions: [
          if (!authProvider.isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            )
        ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (user?.profilePicture != null
                              ? NetworkImage(user!.profilePicture!) as ImageProvider
                              : null),
                      child: _profileImage == null && user?.profilePicture == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  
                  if (user?.testResult != null) ...[
                    const Text(
                      'Your Career Recommendation',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.testResult!['job_title'] ?? 'No title',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(user.testResult!['job_description'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 30),
                  const Text(
                    'Bookmarked Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  if (user?.bookmarkedJobs.isNotEmpty == true) ...[
                    const Text('Jobs:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...user!.bookmarkedJobs.take(3).map((job) => ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(job.title),
                      subtitle: Text(job.company),
                    )),
                  ],
                  
                  if (user?.bookmarkedCourses.isNotEmpty == true) ...[
                    const Text('Courses:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...user!.bookmarkedCourses.take(3).map((course) => ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(course.title),
                      subtitle: Text(course.provider),
                    )),
                  ],
                  
                  if ((user?.bookmarkedJobs.isEmpty ?? true) && 
                      (user?.bookmarkedCourses.isEmpty ?? true)) 
                    const Text('No bookmarks yet'),
                ],
              ),
            ),
    );
  }
}
