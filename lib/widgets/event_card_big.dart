import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/constants/styles/app_styles.dart';
import 'package:hedieaty/views/event/event_card_field_small.dart';
import 'package:hedieaty/views/event/event_details.dart';

import '../models/event_model.dart';
import '../models/user_model.dart';
import '../utils/utils.dart';


class EventCardBig extends StatefulWidget {
  final Event event;
  final User eventCreator;
  final VoidCallback onEventDeleted;

  const EventCardBig({
    super.key,
    required this.event,
    required this.eventCreator,
    required this.onEventDeleted
  });


  @override
  State<EventCardBig> createState() => _EventCardBigState();
}

class _EventCardBigState extends State<EventCardBig> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 35, bottom: 30),
            padding: const EdgeInsets.only(right: 15, left: 20, top: 45, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0.3,
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.eventCreator.name,
                      style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventCardFieldSmall(
                            ico: Icons.celebration_rounded,
                            text: widget.event.eventType
                        ),
                        //  create a function that return the number of the remaining gifts of event
                        // widget.event.isPublic?
                        // FutureBuilder(
                        //     future: GiftService.countUnPledgedGifts(widget.event.userId, widget.event.documentId!),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return const Center(
                        //             child: CircularProgressIndicator());
                        //       } else if (snapshot.hasError) {
                        //         return Center(child: Text(
                        //             'Error: ${snapshot.error}'));
                        //       } else if (!snapshot.hasData ||
                        //           snapshot.data == null) {
                        //         return const Center(
                        //             child: const EventCardFieldSmall(
                        //             ico: Icons.card_giftcard_rounded,
                        //             text: "Remaining Gifts: 0"
                        //           )
                        //         );
                        //       } else {
                        //         return EventCardFieldSmall(
                        //             ico: Icons.card_giftcard_rounded,
                        //             text: "Remaining Gifts: ${snapshot.data}"
                        //         );
                        //       }
                        //     }
                        // )
                        // :FutureBuilder(
                        //     future: GiftRepository().getGiftsCountByEventId(widget.event.id!),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return const Center(
                        //             child: CircularProgressIndicator());
                        //       } else if (snapshot.hasError) {
                        //         return Center(child: Text(
                        //             'Error: ${snapshot.error}'));
                        //       } else if (!snapshot.hasData ||
                        //           snapshot.data == null) {
                        //         return const Center(
                        //             child: const EventCardFieldSmall(
                        //                 ico: Icons.card_giftcard_rounded,
                        //                 text: "Remaining Gifts: 0"
                        //             )
                        //         );
                        //       } else {
                        //         return EventCardFieldSmall(
                        //             ico: Icons.card_giftcard_rounded,
                        //             text: "Remaining Gifts: ${snapshot.data}"
                        //         );
                        //       }
                        //     }
                        // ),
                        EventCardFieldSmall(
                          ico: Icons.event_outlined,
                          text: widget.event.date.isAfter(DateTime.now())? "Upcoming Event": "Past Event",
                          // icon_bg_color: widget.event.isPublic?Colors.orange:Colors.red,
                        ),
                        widget.event.isPublic ?
                        const EventCardFieldSmall(
                          ico: Icons.visibility_outlined,
                          text: "Public Event",
                          // icon_bg_color: Colors.green,
                        ):
                        const EventCardFieldSmall(
                          ico: Icons.visibility_off_outlined,
                          text: "Private Event",
                          icon_bg_color: Colors.red,
                        )
                        // : const EventCardFieldSmall(
                        //   ico: Icons.visibility_outlined,
                        //   text: "Public Event",
                        //   // icon_bg_color: Colors.green,
                        // ),
                      ],
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventCardFieldSmall(
                            ico: Icons.calendar_month,
                            text: formatDate(widget.event.date)
                        ),
                        EventCardFieldSmall(
                            ico: Icons.access_time_outlined,
                            text: TimeOfDay(
                                hour:widget.event.date.hour,
                                minute: widget.event.date.minute
                            ).format(context),
                        ),
                        calculateDaysDifference(widget.event.date) >= 1?
                        EventCardFieldSmall(
                          ico: Icons.timer_outlined,
                          text: "After ${calculateDaysDifference(widget.event.date).toString()} days",
                        ): const SizedBox()
                      ],
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),

                MaterialButton(
                  child: Text(
                    "See Details",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent
                      )
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: const Color(0xFFebebeb),
                      showDragHandle: true,
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return EventDetails(
                          eventData: widget.event,
                          eventCreator: widget.eventCreator,
                          onEventDeleted: widget.onEventDeleted,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(width: 3, color: AppStyles.bgColor),
                horizontal:  BorderSide(width: 3, color: AppStyles.bgColor),
              ),
              borderRadius: BorderRadius.circular(100),

            ),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage("assets/images/male-avatar.png"), fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    spreadRadius: 0.2,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}
