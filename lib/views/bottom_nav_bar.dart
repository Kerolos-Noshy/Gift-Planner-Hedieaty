import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hedieaty/views/event/events_page.dart';
import 'package:hedieaty/views/gifts/gifts_page.dart';
import 'package:hedieaty/views/home/home_page.dart';
import 'package:hedieaty/views/profile/notifications_page.dart';
import 'package:hedieaty/views/profile/profile_page.dart';
import 'package:hedieaty/widgets/notification_circle.dart';
import '../../constants/styles/app_styles.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final appScreens = [
    const HomePage(),
    const EventsPage(),
    const GiftsPage(),
    // const NotificationsPage(),
    const ProfilePage(),
  ];

  //change the index for BottomNavBar
  int _selectedIndex = 0;

  void _onTapChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      body: Center(child: appScreens[_selectedIndex]),
      bottomNavigationBar:
      // GNav(
      //   selectedIndex: _selectedIndex,
      //   onTabChange: _onTapChanged,
      //   gap: 8,
      //   backgroundColor: Colors.black,
      //   color: Colors.grey[500],
      //   activeColor: Colors.grey[50],
      //   // rippleColor: Colors.grey[800]!,
      //   hoverColor: Colors.grey[700]!,
      //   iconSize: 24,
      //   tabs: const [
      //     GButton(
      //       icon: FluentSystemIcons.ic_fluent_home_regular,
      //       text: 'Home',
      //     ),
      //     GButton(
      //       icon: FluentSystemIcons.ic_fluent_calendar_regular,
      //       text: 'Events',
      //     ),
      //     GButton(
      //       icon: FluentSystemIcons.ic_fluent_search_filled,
      //       text: 'Search',
      //     ),
      //     GButton(
      //       icon: FluentSystemIcons.ic_fluent_person_regular,
      //       text: 'Profile',
      //     )
      //   ],
      // ),
      BottomNavigationBar(
        iconSize: 28,
        currentIndex: _selectedIndex,
        onTap: _onTapChanged,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[600],
        // selectedIconTheme: IconThemeData(opacity: 0.2),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // backgroundColor: Colors.grey[100],
        enableFeedback: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_calendar_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_calendar_filled),
            label: "Events",
            tooltip: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_gift_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_gift_filled),
            label: "Gifts",
            tooltip: "Gifts",
          ),
          // BottomNavigationBarItem(
          //   icon: Stack(
          //     alignment: AlignmentDirectional(5, -3.5),
          //       children: [
          //         Icon(FluentSystemIcons.ic_fluent_alert_regular),
          //         NotificationCircle(num:5)
          //       ]
          //   ),
          //   activeIcon: Stack(
          //       alignment: AlignmentDirectional(5, -3.5),
          //       children: [
          //         Icon(FluentSystemIcons.ic_fluent_alert_filled),
          //         NotificationCircle(num:5)
          //       ]
          //   ),
          //   label: "Notifications",
          //   tooltip: "Notifications",
          // ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
            label: "Profile",
            tooltip: "Profile",
          ),
        ],
      ),
    );
  }
}
