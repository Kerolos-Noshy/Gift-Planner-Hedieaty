import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/event_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/friend_service.dart';
import 'package:hedieaty/services/gift_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/widgets/personal_event_card.dart';


import '../../constants/styles/app_styles.dart';
import '../../models/event_model.dart';
import '../../models/gift_model.dart';
import '../../models/repositories/user_repository.dart';
import '../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = AuthService().getCurrentUser();
  User? userData;
  int _friendCount = 0;
  int _eventsCount = 0;
  int _pledgedGiftsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getUserStats();
  }

  Future<void> _loadUserData() async {
    if (currentUser != null) {
      final firebaseUid = currentUser.uid;
      final data = await UserService().getUser(firebaseUid);
      if (data != null) {
        setState(() {
          userData = data;
        });
      }
    }
  }

  Future<void> _getUserStats() async {
    var userid = AuthService().getCurrentUser().uid;

    List<User> friendsList = await FriendService().getFriends(userid);
    int eventsCount = await EventRepository().getEventsCountByUserId(userid);
    List<Gift> pledgedGifts = await GiftService.getPledgedGifts(userid);


    setState(() {
      _friendCount = friendsList.length;
      _eventsCount = eventsCount;
      _pledgedGiftsCount = pledgedGifts.length;
    });

    // print("_friendCount updated to: $_friendCount");
  }

  @override
  Widget build(BuildContext context) {
    //TODO: add edit profile function
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.markaziText(
            textStyle: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600
            )
          )
        ),
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
      ),
      body: userData == null
        ? const Center(child: CircularProgressIndicator())
        :SingleChildScrollView(
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
                              userData!.gender == 'm'?
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
                        userData!.name,
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
                        userData!.phone,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Container(
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
                        ),
                        IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            Navigator.pushNamed(context, AppRoutes.allFriends);
                          },
                          icon: Container(
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
                              Text(
                                _pledgedGiftsCount.toString(),
                                style:  const TextStyle(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text("My Events", style: AppStyles.headLineStyle2, ),
                  ),
                ],
              ),
              FutureBuilder<List<Event>>(
                future: EventRepository().getUserEvents(AuthService().getCurrentUser().uid),
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
                      width: MediaQuery.of(context).size.width,
                      height: 284,
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
                                  return PersonalEventCard(event: event, eventCreator: user,);
                                }
                              }
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20,),
              // TODO: remove this button if the navbar state is not accessible
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IconButton(
                  onPressed: () async {
                    // TODO: check this work correctly
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => BottomNavBar(selectedIndex: 2,),)
                    // );
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
                        const Icon(FluentSystemIcons.ic_fluent_gift_regular, color: Colors.white,),
                        const SizedBox(width: 5,),
                        Text(
                            "My Pledged Gifts",
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
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15)
          ),
        ),

        child: ListView(
          children: [
            // const SizedBox(height: 25,),
            Container(
              // color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/gifts_bg 2.webp'
                    ),
                    fit: BoxFit.cover
                )
              ),
              height: 180,
            ),
            const SizedBox(height: 10,),

            ListTile(
              leading: const Icon(Icons.room_preferences_outlined),
              title: const Text(
                "Preferences",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
              onTap: () {
                print(DateTime(2024, 12, 18, 21, 30).isAfter(DateTime.now()));
              },
            ),
            const ListTile(
              title: Text(
                "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  )
              ),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text(
                  "Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  )
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
