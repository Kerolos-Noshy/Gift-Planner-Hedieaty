import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/views/gifts/gift_item.dart';

import '../../models/event_model.dart';
import '../../models/gift_model.dart';
import '../../services/gift_service.dart';

class GiftsPage extends StatefulWidget {
  const GiftsPage({super.key});

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  Future<List<Map<String, dynamic>>> fetchPledgedGiftsData() async {
    final gifts = await GiftService.getPledgedGifts(AuthService().getCurrentUser().uid);

    return Future.wait(gifts.map((gift) async {
      final event = await EventService().getEventById(gift.giftCreatorId, gift.eventDocId);

      return {
        'gift': gift,
        'event': event,
      };
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            "My Pledged Gifts",
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 15,),


              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchPledgedGiftsData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No pledged gifts found.'));
                  } else {
                    final pledgedGiftsData = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: pledgedGiftsData.length,
                      itemBuilder: (context, index) {
                        final data = pledgedGiftsData[index];
                        final gift = data['gift'] as Gift;
                        final event = data['event'] as Event;

                        return GiftItem(
                          gift: gift,
                          event: event,
                          onDeleteGift: () {},
                          showPledgedGiftDetails: true,
                          // bgColor: Color(0x83CFCAC6),
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        )
      ),
    );
  }
}
