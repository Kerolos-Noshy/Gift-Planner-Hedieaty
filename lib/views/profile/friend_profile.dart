import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/services/friend_service.dart';
import '../../constants/styles/app_styles.dart';
import '../../models/event_model.dart';
import '../../models/repositories/user_repository.dart';
import '../../models/user_model.dart';
import '../../services/gift_service.dart';
import '../../widgets/personal_event_card.dart';

class FriendProfile extends StatefulWidget {
  final User friendData;
  const FriendProfile({super.key, required this.friendData});

  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      appBar: AppBar(
        title: Text(
          "${widget.friendData.name.split(' ')[0]}'s Profile",
          style: GoogleFonts.markaziText(
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600
            )
          )
        ),
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height:20,),
                  Container (
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      image: DecorationImage(
                        image: AssetImage(
                          widget.friendData.gender == 'm'?
                          "assets/images/male-avatar.png":
                          "assets/images/female-avatar.png"
                        ), fit: BoxFit.cover
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(1, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    child: Text(
                      widget.friendData.name,
                      style: GoogleFonts.cairo(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700
                        )
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      widget.friendData.phone,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: EventService().getUserEventsCount(widget.friendData.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text(
                                        'Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text(
                                        "0",
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          ),
                                        ));
                                  } else {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                }
                            ),

                            Text(
                                "Events",
                                style:  GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: FriendService().getFriendsCount(widget.friendData.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text(
                                        'Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text(
                                          "0",
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ));
                                  } else {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                }
                            ),
                            Text(
                                "Friends",
                                style:  GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(vertical: 10,),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: GiftService.getPledgedGifts(widget.friendData.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text(
                                        'Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Center(
                                        child: Text(
                                          "0",
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ));
                                  } else {
                                    return Text(
                                      snapshot.data!.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                }
                            ),
                            Text(
                                "Gifts",
                                style:  GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[500]
                                  ),
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 20, top: 20, bottom: 5),
                  // TODO: remove the view all button
                    child: Text("Events", style: AppStyles.headLineStyle2,)
                ),
              ],
            ),
            FutureBuilder<List<Event>>(
              future: EventService().fetchUserEvents(widget.friendData.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found.'));
                } else {
                  final events = snapshot.data!;
                  return SizedBox(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        // return EventCardBig(event: event, eventCreator: ,);
                        return FutureBuilder(
                            future: UserRepository().getUserById(event.userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data == null) {
                                return const Center(child: Text('No events found.'));
                              } else {
                                User? user = snapshot.data!;
                                return PersonalEventCard(event: event, eventCreator: user, showLastRow: false,);
                              }
                            }
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
