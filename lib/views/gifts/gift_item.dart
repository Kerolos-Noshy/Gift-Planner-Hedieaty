import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:hedieaty/models/repositories/gift_repository.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/gift_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/views/event/text_field_with_icon.dart';
import 'package:hedieaty/views/gifts/add_gift_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/event_model.dart';
import '../../models/gift_model.dart';
import '../../models/user_model.dart';
import '../../utils/utils.dart';


class GiftItem extends StatefulWidget {
  final IconData ico;
  final Color icon_bg_color;
  final Gift gift;
  final Event event;
  final Color bgColor;
  final VoidCallback onDeleteGift;
  final bool showPledgedGiftDetails; // show more details in the My pleadged gifts page

  const GiftItem({
    super.key,
    this.ico = FluentSystemIcons.ic_fluent_gift_filled,
    this.icon_bg_color = Colors.green,
    required this.gift,
    required this.event,
    this.bgColor = Colors.white,
    required this.onDeleteGift,
    this.showPledgedGiftDetails = false,
  });

  @override
  State<GiftItem> createState() => _GiftItemState();
}

class _GiftItemState extends State<GiftItem> {
  bool isEventPassed = false;
  User? pledger;

  @override
  void initState() {
    super.initState();
    isEventPassed = widget.event.date.isBefore(DateTime.now());
    _getPledger();
  }

  Future<void> _getPledger() async{
    if (pledger != null)
      pledger = await UserService().getUser(widget.gift.pledgerId!);

    setState(() {});
  }

  void _onGiftChanged() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0.2, .2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 3),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 7),
        collapsedBackgroundColor: Colors.transparent,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(
          children: [
            const SizedBox(width: 5,),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.gift.pledgerId != null ? Colors.grey : widget.icon_bg_color,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Icon(
                widget.ico,
                color: Colors.grey[200],
                size: 25,
              )
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: Text(
                  widget.gift.name,
                  style: GoogleFonts.lato(textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  )
                )
              ),
            ),
            const SizedBox(width: 5,),

            SizedBox(width: widget.gift.pledgerId != null ? 8 : 18,),
            widget.gift.giftCreatorId == AuthService().getCurrentUser().uid &&
                widget.gift.pledgerId != null?
            const SizedBox():

            // show the pledge button for all user except the creator when the event is upcoming and the gift is not pledged
            widget.gift.pledgerId == null // not pledged
                && !isEventPassed
                && widget.gift.giftCreatorId != AuthService().getCurrentUser().uid?
            IconButton(
              onPressed: () async {
                Gift pledgedGift = widget.gift;
                pledgedGift.pledgerId = AuthService().getCurrentUser().uid;

                try {
                  await GiftService.updateGift(widget.gift.giftCreatorId, widget.event.documentId!, pledgedGift);
                  await GiftRepository().updateGift(pledgedGift);

                  setState(() {

                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gift pledged successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to pledge gift: $e')),
                  );
                }
              },
              // tooltip: widget.gift.pledgerId != null ? "pledger name": null,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.gift.pledgerId != null ? Colors.grey: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
              icon: Text(
                "Pledge",
                style: GoogleFonts.breeSerif(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),
                )
              ),
            )
            :const SizedBox(),
            widget.gift.pledgerId != null &&
                widget.gift.pledgerId == AuthService().getCurrentUser().uid
                && !isEventPassed? // not pledged
            IconButton(
              onPressed: () async {
                Gift pledgedGift = widget.gift;
                pledgedGift.pledgerId = null;
                try {
                  await GiftService.updateGift(widget.gift.giftCreatorId, widget.gift.eventDocId, pledgedGift);
                  await GiftRepository().updateGift(pledgedGift);

                  setState(() {

                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gift unpledged successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to unpledge gift: $e')),
                  );
                }

                setState(() {

                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xD0C30909),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              ),
              icon: Text(
                  "Un Pledge",
                  style: GoogleFonts.breeSerif(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15
                    ),
                  )
              ),
            )
                :const SizedBox(),
            // const SizedBox(width: 5,)
          ],
        ),
        children: [
          widget.gift.description != null && widget.gift.description! != "" ?
          CustomListTile(
            ico: Icons.view_headline_sharp,
            text: widget.gift.description!,
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          )
          :const SizedBox(),

          CustomListTile(
            ico: Icons.category,
            text: widget.gift.category,
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          ),

          CustomListTile(
            ico: Icons.attach_money_rounded,
            text: "${widget.gift.price} EGP",
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          ),


          CustomListTile(
            ico: widget.gift.pledgerId != null?Icons.check:Icons.close,
            text: widget.gift.pledgerId != null?"Pledged":"Not Pledged",
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          ),

          widget.showPledgedGiftDetails?
          FutureBuilder<User?>(
              future: UserService().getUser(widget.gift.giftCreatorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child:
                  LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.orange,
                    size: 30,
                  ),);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No user found.'));
                } else {
                  return CustomListTile(
                    ico: Icons.person,
                    text: snapshot.data!.name,
                    iconSize: 18,
                    iconPadding: 7,
                    bgColor: widget.bgColor,
                    icon_bg_color: const Color(0xE0630FD3),
                  );
                }
              }
          )
          :widget.gift.pledgerId != null?
          FutureBuilder<User?>(
            future: UserService().getUser(widget.gift.pledgerId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child:
                LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.orange,
                  size: 30,
                ),);
              } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No pledger found.'));
              } else {
                return CustomListTile(
                  ico: Icons.person,
                  text: snapshot.data!.name,
                  iconSize: 18,
                  iconPadding: 7,
                  bgColor: widget.bgColor,
                  icon_bg_color: const Color(0xE0630FD3),
                );
              }
            }
          ):const SizedBox(),

          widget.showPledgedGiftDetails?
          CustomListTile(
            ico: Icons.date_range,
            text: formatDate(widget.event.date),
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          ):SizedBox(),

          widget.showPledgedGiftDetails?
          CustomListTile(
            ico: Icons.timer_outlined,
            text: convertTo12HourFormat("${widget.event.date.hour}:${widget.event.date.minute}"),
            iconSize: 18,
            iconPadding: 7,
            bgColor: widget.bgColor,
            icon_bg_color: const Color(0xE0630FD3),
          ):SizedBox(),

          const SizedBox(height: 10,),

          widget.gift.giftCreatorId == AuthService().getCurrentUser().uid &&
              widget.gift.pledgerId == null && !isEventPassed?
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10,),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddGiftPage(
                            gift: widget.gift,
                            event: widget.event,
                            onGiftAdded: _onGiftChanged)
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
                      const Icon(Icons.edit, color: Colors.white,),
                      const SizedBox(width:8,),
                      Text(
                        "Edit",
                        style: GoogleFonts.breeSerif(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      ),
                    ]
                  ),
                ),
              ),

              const SizedBox(width: 15,),

              Expanded(
                child: IconButton(
                  onPressed: () async {
                    try {
                      await GiftRepository().deleteGift(widget.gift.documentId!);
                      await GiftService.deleteGift(
                          widget.gift.giftCreatorId,
                          widget.event.documentId!,
                          widget.gift.documentId!);

                      widget.onDeleteGift();
                      // Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gift deleted successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to deleted gift: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xD0C30909),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  ),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete, color: Colors.white,),
                      const SizedBox(width: 8,),
                      Text(
                        "Delete",
                        style: GoogleFonts.breeSerif(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      ),
                    ]
                  ),
                ),
              ),
              const SizedBox(width: 10,),
            ],
          ) : const SizedBox(),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
