import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'User123';
  XFile? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _resetData() {
    // Implement actual reset logic
    setState(() {
      username = 'User123';
      _profileImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path))
                    : null,
                child: _profileImage == null ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              controller: TextEditingController(text: username),
              onChanged: (value) => username = value,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetData,
              child: const Text('Reset Account Data'),
            )
          ],
        ),
      ),
    );
  }
}
