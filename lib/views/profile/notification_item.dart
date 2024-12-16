import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationItem extends StatelessWidget {
  final String text;
  final String date;
  final Color iconBgColor;

  const NotificationItem({
    super.key,
    required this.text,
    required this.date,
    this.iconBgColor = Colors.orange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f4f3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              FluentSystemIcons.ic_fluent_alert_filled,
              color: Colors.grey[200],
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            date,
            style: GoogleFonts.markaziText(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
