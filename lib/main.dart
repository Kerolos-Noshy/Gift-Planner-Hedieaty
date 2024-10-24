import 'package:flutter/material.dart';
import 'package:hedieaty/routes/app_routes.dart';
import 'package:hedieaty/views/bottom_nav_bar.dart';
import 'package:hedieaty/views/home/all_friends.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.homePage: (context) => const BottomNavBar(),
        AppRoutes.allFriends: (context) => const AllFriends()
      },
    );
  }
}

