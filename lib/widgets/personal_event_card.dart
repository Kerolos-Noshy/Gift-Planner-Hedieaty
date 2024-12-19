import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/user_model.dart';

import '../models/event_model.dart';
import '../utils/utils.dart';
import '../views/event/event_card_field_small.dart';
import '../views/event/event_details.dart';

class PersonalEventCard extends StatefulWidget {
  final Event event;
  final User eventCreator;
  final bool showLastRow;
  const PersonalEventCard({
    super.key,
    required this.event,
    required this.eventCreator,
    this.showLastRow = true,
  });

  @override
  State<PersonalEventCard> createState() => _PersonalEventCardState();
}

class _PersonalEventCardState extends State<PersonalEventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(right: 15, left: 20, top: 15, bottom: 5),
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
                    widget.event.name,
                    style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
                ),
              ],
            ),
            const SizedBox(width: 260, child: Divider(thickness: 1, color: Colors.grey, )),
            const SizedBox(height: 10,),
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
                    // TODO: create a function that return the number of the remaining gifts of event
                    const EventCardFieldSmall(
                        ico: Icons.card_giftcard_rounded,
                        text: "Remaining Gifts: 4"
                    ),
                    // TODO: add a condition for event status (private or public)
                    // widget.event.status == 1 ?
                    widget.showLastRow == true ?
                    const EventCardFieldSmall(
                      ico: Icons.visibility_off_outlined,
                      text: "Private Event",
                      icon_bg_color: Colors.red,
                    ) : const SizedBox()
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
                    // TODO: add a function that calculate the difference between now and event day
                    EventCardFieldSmall(
                      ico: Icons.access_time_outlined,
                      text: TimeOfDay(
                          hour:widget.event.date.hour,
                          minute: widget.event.date.minute
                      ).format(context),
                    ),
                    widget.showLastRow == true ?
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
                    return EventDetails(eventData: widget.event, eventCreator: widget.eventCreator, onEventDeleted: (){},);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
