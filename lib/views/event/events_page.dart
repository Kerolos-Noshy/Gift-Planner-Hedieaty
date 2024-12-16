import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/widgets/event_card_big.dart';


class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            "All Events",
            style: GoogleFonts.markaziText(
                textStyle: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600
                )
            )
        ),
      ),
      // appBar: AppBar(title: Text("All Events"), backgroundColor: Colors.white,),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        child: ListView(
          children: const [
            SizedBox(height: 15,),
            EventCardBig(),
            EventCardBig(),
            EventCardBig(),
            EventCardBig(),
          ],
        ),
      ),
    );
  }
}
