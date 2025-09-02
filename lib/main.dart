import 'package:career_guidance_app/providers/auth_provider.dart';
import 'package:career_guidance_app/screens/input_form_screen.dart';
import 'package:flutter/material.dart';
import 'providers/provider_theme.dart';
import 'screens/course_listing_screen.dart';
import 'screens/help_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/bookmark_provider.dart';
import 'screens/profile_screen.dart';
import 'screens/questionnaire_screen.dart';
import 'screens/results_screen.dart';
import 'screens/job_listings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..autoLogin()),
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
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/input':
                return MaterialPageRoute(
                    builder: (_) => const InputFormScreen());
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginScreen());
              case '/home':
                return MaterialPageRoute(builder: (_) => const HomeScreen());
              case '/questionnaire':
                return MaterialPageRoute(
                    builder: (_) => const QuestionnaireScreen());
              case '/results':
                return MaterialPageRoute(builder: (_) => const ResultScreen());
              case '/recommendations':
                return MaterialPageRoute(
                    builder: (_) => const MainNavigation(initialIndex: 1));
              case '/courses':
                final skill = settings.arguments as String?;
                return MaterialPageRoute(
                    builder: (_) => CourseListingScreen(skill: skill));
              case '/jobs':
                return MaterialPageRoute(
                    builder: (_) => const JobListingsScreen());
              case '/signup':
                return MaterialPageRoute(builder: (_) => const SignupScreen());
              case '/help':
                return MaterialPageRoute(builder: (_) => const HelpScreen());
              case '/main':
                return MaterialPageRoute(
                    builder: (_) => const MainNavigation());
              case '/profile':
                return MaterialPageRoute(
                    builder: (_) => const ProfileScreen());
              default:
                return MaterialPageRoute(builder: (_) => const LoginScreen());
            }
          },
        );
      },
    );
  }
}