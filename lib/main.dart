import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/database/database_helper.dart';
import 'package:hedieaty/routes/app_routes.dart';
import 'package:hedieaty/views/bottom_nav_bar.dart';
import 'package:hedieaty/views/event/add_event_page.dart';
import 'package:hedieaty/views/event/events_page.dart';
import 'package:hedieaty/views/gifts/gifts_page.dart';
import 'package:hedieaty/views/home/all_friends.dart';
import 'package:hedieaty/views/login/login_page.dart';
import 'package:hedieaty/views/profile/notifications_page.dart';
import 'package:hedieaty/views/signup/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp();
  runApp(const MyApp());

  // print(('reset database'));
  // await DatabaseHelper().resetDatabase();
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
        AppRoutes.homePage: (context) => BottomNavBar(),
        AppRoutes.allFriends: (context) => const AllFriends(),
        AppRoutes.notifications: (context) => const NotificationsPage(),
        AppRoutes.addEvent : (context) => AddEventPage(onEventAdded: () {}, event: null,),
        AppRoutes.gifts : (context) => const GiftsPage(),
        AppRoutes.events : (context) => const EventsPage(),
        // AppRoutes.addGift : (context) => const AddGiftPage(gift: null, event: null,),
      },
    );
  }
}

