import 'package:career_guidance_app/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'skill_recommendations_screen.dart';
import 'bookmark_screen.dart';
import 'package:career_guidance_app/widgets/sliding_menu_drawer.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});
  

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    SkillRecommendationsScreen(),
    BookmarkScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _navigateToProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _navigateToHelp(){
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
  }

  void _logout() {
    Navigator.pop(context); // Close drawer
    // You can also redirect to login screen here:
    // Navigator.pushReplacementNamed(context, '/login');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );
  }

  void _exitApp() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');// Optional: You could integrate `SystemNavigator.pop()` or just leave this simple
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WiseChoice')),
      drawer: SlidingMenuDrawer(
        onLogout: _logout,
        onSettings: _navigateToSettings,
        onProfile: _navigateToProfile,
        onHelp: _navigateToHelp,
        onExit: _exitApp,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Recommendations'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
        ],
      ),
    );
  }
}
