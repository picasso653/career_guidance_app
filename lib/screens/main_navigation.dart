import 'package:career_guidance_app/screens/bookmark_screen.dart';
import 'package:career_guidance_app/screens/help_screen.dart';
import 'package:career_guidance_app/screens/home_screen.dart';
import 'package:career_guidance_app/screens/profile_screen.dart';
import 'package:career_guidance_app/screens/settings_screen.dart';
import 'package:career_guidance_app/screens/skill_recommendations_screen.dart';
import 'package:career_guidance_app/widgets/sliding_menu_drawer.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  final int? initialSubIndex;
  final String? initialSkill;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
    this.initialSubIndex,
    this.initialSkill,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  int? _currentSubIndex;
  String? _currentSkill;

  // Screens list - now includes parameter passing
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _currentSubIndex = widget.initialSubIndex;
    _currentSkill = widget.initialSkill;

    // Initialize screens with parameters
    _screens = [
      const HomeScreen(),
      SkillRecommendationsScreen(
        initialTab: _currentSubIndex,
        initialSkill: _currentSkill,
      ),
      const BookmarkScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Reset skill filter when switching tabs
      if (index != 1) {
        _currentSubIndex = null;
        _currentSkill = null;
      }
      
      // Update the recommendations screen when switching to it
      if (index == 1) {
        _screens[1] = SkillRecommendationsScreen(
          initialTab: _currentSubIndex,
          initialSkill: _currentSkill,
        );
      }
    });
  }

  void _navigateToSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _navigateToProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _navigateToHelp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const HelpScreen()));
  }

  void _logout() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _exitApp() {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
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
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: 'Recommendations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmarks'),
        ],
      ),
    );
  }
}