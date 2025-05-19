import 'package:career_guidance_app/screens/input_form_screen.dart';
import 'package:flutter/material.dart';
import 'providers/provider_theme.dart';
import 'screens/help_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/bookmark_provider.dart';
import 'screens/questionnaire_screen.dart';
import 'screens/results_screen.dart';
import 'screens/job_listings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CareerGuidanceApp(),
    ),
  );
}

class CareerGuidanceApp extends StatelessWidget {
  const CareerGuidanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: "Career Guidance App",
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: Colors.white,
          ), // Light theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          routes: {
            '/input': (context) => const InputFormScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/questionnaire': (context) => const QuestionnaireScreen(),
            '/results': (context) => const ResultScreen(),
            '/recommendations': (context) =>
                const MainNavigation(initialIndex: 1),
            '/jobs': (context) => const JobListingsScreen(),
            '/signup': (context) => const SignupScreen(),
            '/help': (context) => const HelpScreen(),
            '/main': (context) => const MainNavigation(),
          },
        );
      },
    );
  }
}
