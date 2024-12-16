import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCardFieldSmall extends StatelessWidget {
  final IconData ico;
  final String text;
  final Color icon_bg_color;

  const EventCardFieldSmall({
    super.key,
    required this.ico,
    required this.text,
    this.icon_bg_color=Colors.orangeAccent
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          // const SizedBox(width: 5,),
          Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: icon_bg_color,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Icon(
                ico,
                color: Colors.grey[100],
                size: 20,)
          ),
          const SizedBox(width: 7,),
          Text(
              text,
              style: GoogleFonts.lato(textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600)
              )
          ),
        ],
      ),
    );
  }
}
