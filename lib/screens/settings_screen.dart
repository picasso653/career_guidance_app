import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _clearBookmarks() {
    // You can implement this using your BookmarkProvider
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Bookmarks'),
        content: const Text('Are you sure you want to clear all bookmarks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Call provider method to clear bookmarks
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmarks cleared')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: (val) {
              themeProvider.toggleTheme(val);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_remove),
            title: const Text('Clear All Bookmarks'),
            onTap: _clearBookmarks,
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Help & Contact'),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('WiseChoice v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'WiseChoice',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 WiseChoice',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              // Future feature
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
