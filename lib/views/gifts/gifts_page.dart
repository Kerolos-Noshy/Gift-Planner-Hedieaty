import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/views/gifts/gift_item.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/event_model.dart';
import '../../models/gift_model.dart';
import '../../services/gift_service.dart';

class GiftsPage extends StatefulWidget {
  const GiftsPage({super.key});

  @override
  State<GiftsPage> createState() => _GiftsPageState();
}

class _GiftsPageState extends State<GiftsPage> {
  late Future<List<Map<String, dynamic>>> _giftsFuture;
  List<Map<String, dynamic>> _sortedGifts = [];
  String _sortCriterion = 'Name';

  @override
  void initState() {
    super.initState();
    _giftsFuture = fetchAndSortGifts();
  }

  Future<List<Map<String, dynamic>>> fetchAndSortGifts() async {
    final gifts = await GiftService.getPledgedGifts(AuthService().getCurrentUser().uid);

    final pledgedGiftsData = await Future.wait(gifts.map((gift) async {
      final event = await EventService().getEventById(gift.giftCreatorId, gift.eventDocId);
      return {'gift': gift, 'event': event};
    }).toList());

    // Sort data before assigning to _sortedGifts
    pledgedGiftsData.sort((a, b) {
      final giftA = a['gift'] as Gift;
      final giftB = b['gift'] as Gift;

      switch (_sortCriterion) {
        case 'Category':
          return giftA.category.compareTo(giftB.category);
        case 'Status':
        // Sort by whether `pledger_id` is null or not
          final isPledgedA = giftA.pledgerId != null ? 0 : 1;
          final isPledgedB = giftB.pledgerId != null ? 0 : 1;
          return isPledgedA.compareTo(isPledgedB);
        case 'Name':
        default:
          return giftA.name.compareTo(giftB.name);
      }
    });

    return pledgedGiftsData;
  }

  void _sortGifts(String criterion) {
    setState(() {
      _sortCriterion = criterion;

      _sortedGifts.sort((a, b) {
        final giftA = a['gift'] as Gift;
        final giftB = b['gift'] as Gift;

        switch (_sortCriterion) {
          case 'Category':
            return giftA.category.compareTo(giftB.category);
          case 'Status':
            return giftA.status.compareTo(giftB.status);
          case 'Name':
          default:
            return giftA.name.compareTo(giftB.name);
        }
      });
    });
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
            textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          const Icon(Icons.sort_outlined),
          const SizedBox(width: 5),
          DropdownButton<String>(
            dropdownColor: Colors.white,
            value: _sortCriterion,
            items: [
              DropdownMenuItem(
                value: 'Name',
                child: Text('Name',
                  style: GoogleFonts.markaziText(
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                )
              ),
              DropdownMenuItem(
                  value: 'Category',
                  child: Text('Category',
                  style: GoogleFonts.markaziText(
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                  )
              ),
              DropdownMenuItem(
                  value: 'Status',
                  child: Text('Status',
                    style: GoogleFonts.markaziText(
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                  )),
            ],
            onChanged: (value) {
              if (value != null) {
                _sortGifts(value);
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [

              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _giftsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child:
                      LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.orange,
                        size: 30,
                      ),);
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No pledged gifts found.'));
                    } else {
                      _sortedGifts = snapshot.data!;
                      return ListView.builder(
                        itemCount: _sortedGifts.length,
                        itemBuilder: (context, index) {
                          final data = _sortedGifts[index];
                          final gift = data['gift'] as Gift;
                          final event = data['event'] as Event;

                          return GiftItem(
                            gift: gift,
                            event: event,
                            onDeleteGift: () {},
                            showPledgedGiftDetails: true,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
