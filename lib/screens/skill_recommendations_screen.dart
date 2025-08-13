import 'package:career_guidance_app/screens/job_listings_screen.dart';
import 'package:flutter/material.dart';

import 'course_listing_screen.dart';

class SkillRecommendationsScreen extends StatefulWidget {
  final int? initialTab;
  final String? initialSkill;
  const SkillRecommendationsScreen(
      {super.key,
      this.initialTab,
      this.initialSkill,
      });

  @override
  State<SkillRecommendationsScreen> createState() =>
      _SkillRecommendationsScreenState();
}

class _SkillRecommendationsScreenState
    extends State<SkillRecommendationsScreen> {
  bool showCourses = true;
  String? currentSkill;

  @override
  void initState() {
    super.initState();
    showCourses = widget.initialTab == null ? true : widget.initialTab == 0;
    currentSkill = widget.initialSkill;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_0.png',
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text('Recommendations')
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showCourses = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: showCourses ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(child: Text('Courses')),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showCourses = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !showCourses ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(child: Text('Jobs')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: showCourses
                ? CourseListingScreen(skill: currentSkill)
                : const JobListingsScreen(),
          ),
        ],
      ),
    );
  }
}
