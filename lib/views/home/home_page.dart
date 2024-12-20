import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/event_model.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/services/friend_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/widgets/event_card_big.dart';

import '../../routes/app_routes.dart';
import '../../widgets/section_header_view_all.dart';
import '../../widgets/friend_avatar.dart';
import '../../constants/styles/app_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: const Color(0xffcfcfcf),
            centerTitle: true,
            backgroundColor: const Color(0xFFf5f4f3),
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: false,
            expandedHeight: 170,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                  alignment: AlignmentDirectional.bottomCenter.add(
                      const AlignmentDirectional(0, 0.3)),
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/images/gifts_bg 3.jpg'),
                            fit: BoxFit.cover
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 13,
                            offset: const Offset(-1, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(
                          left: 20,
                          top: 75,
                      ),
                      // child: Text(
                      //     "Hedieaty",
                      //     style: GoogleFonts.pacifico(
                      //         textStyle: AppStyles.headLineStyle1.copyWith(
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 32,
                      //             color: const Color(0xFFe3c399)
                      //         )
                      //     )
                      // ),
                    ),
                  ]
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Hedieaty",
                    style: GoogleFonts.pacifico(
                        textStyle: AppStyles.headLineStyle1.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: const Color(0xFFe3c399)
                        )
                    )
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    FutureBuilder(
                        future: UserService().getUser(AuthService().getCurrentUser().uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text(
                                'Error: ${snapshot.error}'));
                          } else
                          if (!snapshot.hasData || snapshot.data! == null) {
                            return const SizedBox();
                          } else {
                            return Row(
                              children: [
                                Text(
                                    "Hello, ${snapshot.data!.name.split(' ')[0]}!",
                                    style: GoogleFonts.cairo(
                                        textStyle: AppStyles.headLineStyle2.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30,
                                        )
                                    )
                                ),

                              ],
                            );
                          }
                        }
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SectionHeaderViewAll(
                  text: "Friends",
                  route: AppRoutes.allFriends,
                ),
              ),
              // const SizedBox(height: 10,),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width*.95,
                child: FutureBuilder<List<User>>(
                  future: FriendService().getFriends(AuthService().getCurrentUser().uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No friends found.'));
                    } else {
                      List<User> friends = snapshot.data!;
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            final friend = friends[index];
                            return FutureBuilder(
                                future: EventService().fetchUserEvents(friend.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data == null) {
                                    return const Center(child: Text('No friends found.'));
                                  } else {
                                    List<Event>? events = snapshot.data;
                                    int eventsCount = 0;
                                    // count only the upcoming events
                                    for (Event e in events!) {
                                      if (e.date.isAfter(DateTime.now())) {
                                        eventsCount += 1;
                                      }
                                    }

                                    return Row(
                                      children: [
                                        const SizedBox(width: 15,),
                                        FriendAvatar(friend: friend, eventsCount: eventsCount),
                                      ],
                                    );
                                  }
                                }
                            );
                          }
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

                    child: Text("Next Week Events", style: AppStyles.headLineStyle2,),
                  ),
                ],
              ),
              // const SizedBox(height: 10,),
              // FutureBuilder(
              //     future: EventService().fetchEventsForNext7Days(),
              //     builder: builder
              // )
              const SizedBox(height: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 347,
                child: FutureBuilder<List<Event?>>(
                  future: EventService().fetchEventsForNext7Days(AuthService().getCurrentUser().uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No events found.'));
                    } else {
                      final events = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: false,

                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return FutureBuilder(
                              future: UserService().getUser(event!.userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data == null) {
                                  return const Center(child: Text('No friends found.'));
                                } else {
                                  User eventCreator = snapshot.data!;

                                  return EventCardBig(
                                    event: event,
                                    eventCreator: eventCreator,
                                    onEventDeleted: () {},
                                  );
                                }
                              }
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addEvent);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),

                  icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white,),
                        const SizedBox(width: 2,),
                        Text(
                            "Create Your Own Event",
                            style: GoogleFonts.breeSerif(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            )
                        ),
                        const SizedBox(width: 8,),
                      ]
                  ),
                ),
              ),
              const SizedBox(height: 30,)
            ],
          ),
          )
        ],

      ),
    );
  }
}
