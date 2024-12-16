import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            "Gifts",
            style: GoogleFonts.markaziText(
                textStyle: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600
                )
            )
        ),
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15,),
            ],
          )
      ),
    );
  }
}
