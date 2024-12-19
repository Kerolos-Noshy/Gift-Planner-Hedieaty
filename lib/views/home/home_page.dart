import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/event_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/friend_service.dart';

import '../../routes/app_routes.dart';
import '../../widgets/section_header_view_all.dart';
import '../../widgets/event_card.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                      top: 75
                    ),
                    child: Text(
                      "Hedieaty",
                      style: GoogleFonts.pacifico(
                        textStyle: AppStyles.headLineStyle1.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: const Color(0xFFe3c399)
                        )
                      )
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 20,),

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
                            // TODO: get the events count from fire store
                              future: EventRepository().getEventsCountByUserId(friend.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data! == null) {
                                  return const Center(child: Text('No friends found.'));
                                } else {
                                  return Row(
                                    children: [
                                      const SizedBox(width: 15,),
                                      FriendAvatar(friend: friend),
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
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SectionHeaderViewAll(
                  text: "Next Week Events",
                  route: AppRoutes.allFriends,
                ),
              ),
              // const SizedBox(height: 10,),
              const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5, ),
                    child: Row(
                      children: [
                        EventCard(date:"20-Nov-2024"),
                        EventCard(date:"20-Nov-2024"),
                        EventCard(date:"20-Nov-2024"),
                      ]
                    ),
                  )
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
            ],
        ),
      ),
    );
  }
}
