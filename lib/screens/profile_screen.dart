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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: isDarkMode ? Colors.deepPurple[800] : Colors.purple[200],
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
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
                  Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode ? Colors.deepPurple[400]! : Colors.purple[300]!,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(_profileImage!, fit: BoxFit.cover)
                              : (user?.profilePicture != null
                                  ? Image.network(user!.profilePicture!, fit: BoxFit.cover)
                                  : Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[400],
                                    )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode ? Colors.deepPurple[400] : Colors.purple[300],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 20),
                            color: Colors.white,
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode ? Colors.deepPurple[400]! : Colors.purple[400]!,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              prefixIcon: Icon(
                                Icons.badge,
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode ? Colors.deepPurple[400]! : Colors.purple[400]!,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: isDarkMode ? Colors.deepPurple[400]! : Colors.purple[400]!,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  if (user?.testResult != null) ...[
                    Text(
                      'Your Career Recommendation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: isDarkMode ? Colors.deepPurple[900] : Colors.purple[50],
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.work,
                                  color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  user!.testResult!['job_title'] ?? 'No title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              user.testResult!['job_description'] ?? '',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 30),
                  Text(
                    'Bookmarked Items',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  if (user?.bookmarkedJobs.isNotEmpty == true) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Jobs',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                        ),
                      ),
                    ),
                    ...user!.bookmarkedJobs.take(3).map((job) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.work,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                        ),
                        title: Text(
                          job.title,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          job.company,
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    )),
                  ],
                  
                  if (user?.bookmarkedCourses.isNotEmpty == true) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Courses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                        ),
                      ),
                    ),
                    ...user!.bookmarkedCourses.take(3).map((course) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: isDarkMode ? Colors.deepPurple[800] : Colors.purple[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.school,
                          color: isDarkMode ? Colors.deepPurple[200] : Colors.purple[700],
                        ),
                        title: Text(
                          course.title,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          course.provider,
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    )),
                  ],
                  
                  if ((user?.bookmarkedJobs.isEmpty ?? true) && 
                      (user?.bookmarkedCourses.isEmpty ?? true)) 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No bookmarks yet',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}