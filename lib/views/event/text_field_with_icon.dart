import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWithIcon extends StatelessWidget {
  final IconData ico;
  final String text;
  final Color icon_bg_color;
  final double iconSize;
  final double fontSize;
  final double iconPadding;

  const TextFieldWithIcon({
    super.key,
    required this.ico,
    required this.text,
    this.icon_bg_color=Colors.orange,
    this.iconSize = 26,
    this.fontSize = 15,
    this.iconPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          const SizedBox(width: 5,),
          Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                  color: icon_bg_color,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Icon(
                ico,
                color: Colors.grey[200],
                size: iconSize,)
          ),
          const SizedBox(width: 15,),
          Expanded(
            child: Text(
                text,
                style: GoogleFonts.lato(textStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600)
                )
            ),
          ),
        ],
      ),
    );
  }
}
