import 'package:flutter/material.dart';

class SlidingMenuDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSettings;
  final VoidCallback onProfile;
  final VoidCallback onHelp;
  final VoidCallback onExit;

  const SlidingMenuDrawer({
    super.key,
    required this.onLogout,
    required this.onSettings,
    required this.onProfile,
    required this.onHelp,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: onProfile,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: onSettings,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: onLogout,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit App'),
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}