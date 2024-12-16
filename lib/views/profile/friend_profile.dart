import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/repositories/event_repository.dart';
import '../../models/repositories/friend_repository.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/personal_event_card.dart';
import '../../widgets/section_header_view_all.dart';

class FriendProfile extends StatefulWidget {
  final User friendData;
  const FriendProfile({super.key, required this.friendData});

  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  int _friendCount = 0;
  int _eventsCount = 0;
  int _giftsCount = 0;

  @override
  void initState() {
    super.initState();
    _getUserStats();
  }

  Future<void> _getUserStats() async {
    var userid = widget.friendData.id;

    // Fetch data before updating the state
    List<User> friendsList = await FriendRepository().getAllFriends(userid);
    int eventsCount = await EventRepository().getEventsCountByUserId(userid);

    // Update the state once data is ready
    setState(() {
      _friendCount = friendsList.length;
      _eventsCount = eventsCount;
    });

    // print("_friendCount updated to: $_friendCount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      appBar: AppBar(
        title: Text(
            "${widget.friendData.name.split(' ')[0]}'s Profile",
            style: GoogleFonts.markaziText(
              textStyle: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600
              )
            )
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height:20,),
                  Container (
                    height: 140,
                    width: 140,
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
                      widget.friendData.email,
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
                            Text(
                              _eventsCount.toString(),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
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
                            Text(
                              "$_friendCount",
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
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
                            const Text(
                              "30",
                              style:  TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
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
            const Padding(
              padding: EdgeInsets.only(left: 25, right: 20),
              child: SectionHeaderViewAll(
                text: "Events",
                route: AppRoutes.allFriends,
              ),
            ),
            const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:25, vertical: 10, ),
                  child: Row(
                      children: [
                        PersonalEventCard(),
                        PersonalEventCard(),
                        PersonalEventCard(),
                      ]
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
