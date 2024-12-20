import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/event_repository.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/services/gift_service.dart';
import 'package:hedieaty/views/event/event_gift_list.dart';

import '../../models/event_model.dart';
import '../../models/user_model.dart';
import '../../utils/utils.dart';
import 'add_event_page.dart';
import 'text_field_with_icon.dart';

class EventDetails extends StatefulWidget {
  final Event eventData;
  final User eventCreator;
  final VoidCallback onEventDeleted;

  const EventDetails({
    super.key,
    required this.eventData,
    required this.eventCreator,
    required this.onEventDeleted,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  static const double _itemsMargin = 15;
  late Event _event;
  bool giftsPledged = false;


  @override
  void initState() {
    super.initState();
    _event = widget.eventData;
    _getPledgedGiftsNumber();
  }

  Future<void> _getPledgedGiftsNumber() async {
    int pledgedGiftsNum;
    if (_event.documentId != null)
      pledgedGiftsNum = await GiftService.countPledgedGifts(AuthService().getCurrentUser().uid, _event.documentId!);
    else
      pledgedGiftsNum = 0;

    giftsPledged = pledgedGiftsNum > 0;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 1,
      snap: true,
      snapSizes: const [0.55,1],
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Event Details",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 0.8, height: 0,),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(1, 5),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        widget.eventCreator.gender == 'm'?
                                        "assets/images/male-avatar.png":
                                        "assets/images/female-avatar.png"
                                    ), fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            Text(
                                widget.eventCreator.name,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50,),
              
                      // const SizedBox(height: 20,),
                      CustomListTile(
                        ico: Icons.celebration_rounded,
                        text: _event.eventType,
                        // icon_bg_color: Color(0xB62C0A98)
                      ),
                      const SizedBox(height: _itemsMargin,),
                      // TODO: add upcoming event or past status

                      CustomListTile(
                        ico: Icons.calendar_month,
                        text: formatDate(_event.date),
              
                        trailing: widget.eventData.date.isAfter(DateTime.now()) && calculateDaysDifference(_event.date) > 0?
                        "after ${calculateDaysDifference(_event.date).toString()} days" : "",
                        // icon_bg_color: Color(0xB62C0A98)
                      ),
              
                      const SizedBox(height: _itemsMargin,),
              
                      CustomListTile(
                        ico: Icons.access_time_rounded,
                        text: TimeOfDay(
                            hour:_event.date.hour,
                            minute: _event.date.minute
                        ).format(context),
                        // icon_bg_color: Color(0xB62C0A98)
                      ),
              
                      const SizedBox(height: _itemsMargin,),
              
                      CustomListTile(
                        ico: Icons.location_on_rounded,
                        text: _event.location,
                      ),
              
                      const SizedBox(height: _itemsMargin,),
              
                      _event.description.isNotEmpty?
                      CustomListTile(
                          ico: Icons.view_headline_sharp,
                          text: _event.description
                      )
                          : const SizedBox(height: 0,),
                      // widget.eventData.isPublic ?
                      // const SizedBox() :
                      // SwitchListTile(
                      //   // inactiveThumbColor: Colors.white,
                      //   inactiveTrackColor: const Color(0xFFf5f4f3),
                      //   activeTrackColor: Colors.green,
                      //   title: const Text("Make It Public?", style: TextStyle(fontSize: 17),),
                      //   secondary: const Icon(Icons.public, size: 26,),
                      //   value: _isPublic,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _isPublic = value;
                      //     });
                      //   },
                      // ),
              
                      _event.description.isNotEmpty?
                      const SizedBox(height: _itemsMargin,)
                          : const SizedBox(),
                      widget.eventCreator.id == AuthService().getCurrentUser().uid
                          && widget.eventData.date.isAfter(DateTime.now())?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEventPage(event: widget.eventData, onEventAdded: widget.onEventDeleted,),
                                  ),
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
                                    const SizedBox(width: 2,),
                                    Text(
                                      "Edit",
                                      style: GoogleFonts.breeSerif(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      )
                                    ),
                                    const SizedBox(width: 7,),
                                  ]
                              ),
                            ),
                          ),
                          _event.isPublic ? const SizedBox():
                          const SizedBox(width: 13,),
              
                          _event.isPublic ? const SizedBox():
                          Expanded(
                            // width: MediaQuery.of(context).size.width*0.4,
                            child: IconButton(
                              onPressed: () async {
                                Event updatedEvent = _event;
                                updatedEvent.isPublic = true;
                                String? eventId = await EventService().addEvent(AuthService().getCurrentUser().uid, updatedEvent);
                                updatedEvent.documentId = eventId;
                                await EventRepository().updateEvent(updatedEvent);
                                await EventService().updateEvent(AuthService().getCurrentUser().uid, updatedEvent);
              
                                setState(() {
                                  _event = updatedEvent;
                                });
                                Navigator.of(context).pop();
                                widget.onEventDeleted();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Event published successfully!")),
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
                                    const Icon(Icons.cloud_upload_outlined, color: Colors.white,),
                                    const SizedBox(width: 2,),
                                    Text(
                                      "Publish",
                                      style: GoogleFonts.breeSerif(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      )
                                    ),
                                    const SizedBox(width: 7,),
                                  ]
                              ),
                            ),
                          ),

                          // hide this button if any gift is pledged
                          giftsPledged? const SizedBox():
                          _event.isPublic ? const SizedBox(width: 20,):
                          const SizedBox(width: 13,),

                          giftsPledged?
                          const SizedBox()
                          :Expanded(
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text('Are you sure you want to delete this event?'),
                                      actions: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Text(
                                              "Cancel",
                                              style: GoogleFonts.breeSerif(
                                                textStyle: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15,

                                                ),
                                              )
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            try {

                                              Navigator.of(context).pop();

                                              if (widget.eventData.isPublic)
                                                await EventService().deleteEventWithGifts(AuthService().getCurrentUser().uid, widget.eventData.documentId!);

                                              await EventRepository().deleteEventWithGifts(widget.eventData.id!);
                                              // setState(() {
                                              //
                                              // });
                                              widget.onEventDeleted();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Event deleted successfully')),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Error deleting event: $e')),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 1),
                                          ),
                                          icon: SizedBox(
                                            width: 90,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.delete, color: Colors.white, size: 22,),
                                                  const SizedBox(width: 8,),
                                                  Text(
                                                      "Delete",
                                                      style: GoogleFonts.breeSerif(
                                                        textStyle: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                  ),
                                                  const SizedBox(width: 4,),
                                                ]
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
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
                                    const SizedBox(width: 2,),
                                    Text(
                                        "Delete",
                                        style: GoogleFonts.breeSerif(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        )
                                    ),
                                    const SizedBox(width: 7,),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      )
                          :const SizedBox(),
                      const SizedBox(height: 10,),
              
                      const Divider(),
                      const SizedBox(height: 10,),

                      EventGiftList(eventCreator: widget.eventCreator ,event: widget.eventData,),
                    ],
                  )
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
