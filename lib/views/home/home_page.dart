import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/user_model.dart';

import '../../models/friend_model.dart';
import '../../models/repositories/friend_repository.dart';
import '../../routes/app_routes.dart';
import '../../utils/all_json.dart';
import '../../widgets/section_header_view_all.dart';
import '../../widgets/event_card.dart';
import '../../widgets/friend_avatar.dart';
import '../../constants/styles/app_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: ListView(
          // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "HEDIEATY",
                    style: GoogleFonts.poppins(
                      textStyle: AppStyles.headLineStyle1.copyWith(fontWeight: FontWeight.w700, fontSize: 23)
                    )
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            spreadRadius: 1,
                            blurRadius: 10,
                            // offset: const Offset(1, 5),
                          ),
                        ],
                      image: const DecorationImage(image: AssetImage("assets/images/logo.png"))
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SectionHeaderViewAll(
                text: "Friends",
                route: AppRoutes.allFriends,
              ),
            ),
            const SizedBox(height: 10,),
            FutureBuilder<List<User>>(
              future: FriendRepository().getFriends(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No friends found.'));
                } else {
                  // Now we have the friends data from the database
                  List<User> friends = snapshot.data!;
                  // print(friends.map((friend) => friend.name));
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        // Limit the number of friends displayed to 5
                        children: friends.take(5).map((singleFriend) => FriendAvatar(friend: singleFriend)).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SectionHeaderViewAll(
                text: "Upcoming Events",
                route: AppRoutes.allFriends,
              ),
            ),
            const SizedBox(height: 10,),
            const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10, ),
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
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12)
                ),
                child: Text(
                  "Create Your Own Event/List",
                  style: AppStyles.headLineStyle3.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
      ),
    );
  }
}
