import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/routes/app_routes.dart';
import 'package:hedieaty/views/bottom_nav_bar.dart';
import 'package:hedieaty/views/home/all_friends.dart';
import 'package:hedieaty/views/login/login_page.dart';
import 'package:hedieaty/views/profile/notifications_page.dart';
import 'package:hedieaty/views/signup/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home : const LoginPage(),

      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signup: (context) => const SignupPage(),
        AppRoutes.homePage: (context) => const BottomNavBar(),
        AppRoutes.allFriends: (context) => const AllFriends(),
        AppRoutes.notifications: (context) => const NotificationsPage(),
        // AppRoutes.
      },
    );
  }
}

