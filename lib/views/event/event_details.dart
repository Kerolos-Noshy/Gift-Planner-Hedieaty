import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/services/auth_service.dart';

import '../../models/event_model.dart';
import '../../models/user_model.dart';
import '../../utils/utils.dart';
import '../gifts/gift_item.dart';
import 'text_field_with_icon.dart';

class EventDetails extends StatefulWidget {
  final Event eventData;
  final User eventCreator;

  const EventDetails({
    super.key,
    required this.eventData,
    required this.eventCreator
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  static const double _itemsMargin = 15;

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
                              text: widget.eventData.eventType,
                              // icon_bg_color: Color(0xB62C0A98)
                            ),
                            const SizedBox(height: _itemsMargin,),
                            // TODO: if the event passed hide the visibility and the remaining days from the event card
                            widget.eventData.date.isAfter(DateTime.now())?
                            CustomListTile(
                              ico: Icons.calendar_month,
                              text: formatDate(widget.eventData.date),

                              trailing: calculateDaysDifference(widget.eventData.date) > 0?
                              "after ${calculateDaysDifference(widget.eventData.date).toString()} days" : "",
                              // icon_bg_color: Color(0xB62C0A98)
                            ): const SizedBox(),

                            const SizedBox(height: _itemsMargin,),

                            CustomListTile(
                              ico: Icons.access_time_rounded,
                              text: TimeOfDay(
                                  hour:widget.eventData.date.hour,
                                  minute: widget.eventData.date.minute
                              ).format(context),
                              // icon_bg_color: Color(0xB62C0A98)
                            ),

                            const SizedBox(height: _itemsMargin,),

                            CustomListTile(
                              ico: Icons.location_on_rounded,
                              text: widget.eventData.location,
                            ),

                            const SizedBox(height: _itemsMargin,),

                            widget.eventData.description.isNotEmpty?
                            CustomListTile(
                                ico: Icons.view_headline_sharp,
                                text: widget.eventData.description
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

                            widget.eventData.description.isNotEmpty?
                            const SizedBox(height: _itemsMargin,)
                                : const SizedBox(),
                            widget.eventCreator.id == AuthService().getCurrentUser().uid?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {},
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
                                          const SizedBox(width: 15,),
                                        ]
                                    ),
                                  ),
                                ),
                                widget.eventData.isPublic ? const SizedBox():
                                const SizedBox(width: 20,),

                                widget.eventData.isPublic ? const SizedBox():
                                Expanded(
                                  // width: MediaQuery.of(context).size.width*0.4,
                                  child: IconButton(
                                    onPressed: () {},
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
                                          const SizedBox(width: 15,),
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
                            Text(
                              "Gifts List",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                              ),
                            ),
                            const SizedBox(height: 15,),
                            GiftItem(
                              text: "Messi's T-Shirt",
                              isPledged: true,
                              giftCreator: widget.eventCreator,
                              // icon_bg_color: Colors.grey,
                            ),
                            GiftItem(
                              text: "Messi's T-Shirt Messi's T-Shirt Messi's T-Shirt",
                              giftCreator: widget.eventCreator,
                            ),
                            GiftItem(
                              text: "Messi's T-Shirt",
                              giftCreator: widget.eventCreator,
                            ),
                            GiftItem(
                              text: "Messi's T-Shirt",
                              giftCreator: widget.eventCreator,
                            ),

                            const SizedBox(height: 10,),

                            // TODO: show add gift button for the event creator only
                            widget.eventCreator.id == AuthService().getCurrentUser().uid?
                            IconButton(
                              onPressed: () {},
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
                            ):
                            const SizedBox(),
                          ],
                        )


                    )
                ),
              ),
          ],
        );
      },
    );
  }
}
