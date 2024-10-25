import 'package:flutter/material.dart';

class NotificationCircle extends StatelessWidget {
  final int upcomingEventsNum;
  const NotificationCircle({super.key, this.upcomingEventsNum=0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red[600]
      ),
      margin: const EdgeInsets.only(right: 10),
      child: Center(
        child: Text(
          "$upcomingEventsNum",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
