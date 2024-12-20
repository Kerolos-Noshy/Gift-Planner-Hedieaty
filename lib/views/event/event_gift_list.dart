import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/gift_repository.dart';
import 'package:hedieaty/services/gift_service.dart';

import '../../models/event_model.dart';
import '../../models/gift_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../gifts/add_gift_page.dart';
import '../gifts/gift_item.dart';

class EventGiftList extends StatefulWidget {
  final User eventCreator;
  final Event event;

  const EventGiftList({
    super.key,
    required this.eventCreator,
    required this.event,
  });

  @override
  State<EventGiftList> createState() => _EventGiftListState();
}

class _EventGiftListState extends State<EventGiftList> {
  List<Gift> gifts = [];

  Future<void> _fetchGifts() async {
    if (widget.event.userId != AuthService().getCurrentUser().uid || widget.event.isPublic)
      gifts = await GiftService.fetchEventGifts(widget.event.userId, widget.event.documentId!);
    else {
      if (widget.event.id != null)
        gifts = await GiftRepository().getGiftsByEventId(widget.event.id!);
    }
    setState(() { });
  }

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: add sortable by name, category, and status
    return Column(
      children: [
        Text(
          "Gifts List",
          style: GoogleFonts.lato(
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
          ),
        ),
        const SizedBox(height: 15,),
        widget.event.userId != AuthService().getCurrentUser().uid ?
        FutureBuilder<List<Gift>>(
          future: GiftService.fetchEventGifts(widget.event.userId, widget.event.documentId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center();
            } else {
              final gifts = snapshot.data!;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return GiftItem(
                    gift: gift,
                    event: widget.event,
                    onDeleteGift: _fetchGifts
                  );
                },
              );
            }
          },
        ) : widget.event.id != null?
        FutureBuilder<List<Gift>>(
          future: GiftRepository().getGiftsByEventId(widget.event.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center();
            } else {
              final gifts = snapshot.data!;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return GiftItem(
                    gift: gift,
                    event: widget.event,
                    onDeleteGift: _fetchGifts,
                  );
                },
              );
            }
          },
        ) : const SizedBox(),



        const SizedBox(height: 10,),
        widget.eventCreator.id == AuthService().getCurrentUser().uid
            && widget.event.date.isAfter(DateTime.now())?
        IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGiftPage(
                  gift: null,
                  event: widget.event,
                  onGiftAdded: _fetchGifts
                )
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          ),

          icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white,),
                const SizedBox(width: 2,),
                Text(
                  "Add Gift",
                  style: GoogleFonts.breeSerif(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ),
                const SizedBox(width: 8,),
              ]
          ),
        )
            :const SizedBox(),
      ],
    );
  }
}
