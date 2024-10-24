import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hedieaty/views/home/home.dart';
import 'package:hedieaty/views/res/styles/app_styles.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final appScreens = [
    const Home(),
    const Text("Events"),
    const Text("Search"),
    const Text("Profile"),
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
      backgroundColor: AppStyles.bgColor,
      body: Center(child: appScreens[_selectedIndex]),
      bottomNavigationBar:
      GNav(
        selectedIndex: _selectedIndex,
        onTabChange: _onTapChanged,
        gap: 8,
        backgroundColor: Colors.black,
        color: Colors.grey[400],
        activeColor: Colors.grey[50],
        // rippleColor: Colors.grey[800]!,
        hoverColor: Colors.grey[700]!,
        iconSize: 24,
        tabs: const [
          GButton(
            icon: FluentSystemIcons.ic_fluent_home_regular,
            text: 'Home',
          ),
          GButton(
            icon: FluentSystemIcons.ic_fluent_calendar_regular,
            text: 'Events',
          ),
          GButton(
            icon: FluentSystemIcons.ic_fluent_search_filled,
            text: 'Search',
          ),
          GButton(
            icon: FluentSystemIcons.ic_fluent_person_regular,
            text: 'Profile',
          )
        ],
      ),
      // BottomNavigationBar(
      // currentIndex: _selectedIndex,
      // onTap: _onTapChanged,
      // selectedItemColor: Colors.blueGrey,
      // unselectedItemColor: const Color(0xFF526400),
      // // showSelectedLabels: false,
      // items: const [
      //   BottomNavigationBarItem(
      //       icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
      //       activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
      //       label: "Home"
      //   ),
      //   BottomNavigationBarItem(
      //       icon: Icon(FluentSystemIcons.ic_fluent_calendar_regular),
      //       activeIcon: Icon(FluentSystemIcons.ic_fluent_calendar_filled),
      //       label: "Search"
      //   ),
      //   BottomNavigationBarItem(
      //       icon: Icon(FluentSystemIcons.ic_fluent_search_regular),
      //       activeIcon: Icon(FluentSystemIcons.ic_fluent_search_filled),
      //       label: "Tickets"
      //   ),
      //   BottomNavigationBarItem(
      //       icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
      //       activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
      //       label: "Profile"
      //   ),
      // ],),
    );
  }
}
