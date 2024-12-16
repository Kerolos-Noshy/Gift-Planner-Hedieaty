import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';

import '../../models/repositories/friend_repository.dart';
import '../../routes/app_routes.dart';
import '../../widgets/section_header_view_all.dart';
import '../../widgets/event_card.dart';
import '../../widgets/friend_avatar.dart';
import '../../constants/styles/app_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter.add(AlignmentDirectional(0, 0.3)),
                children: [
                  Container(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/gifts_bg 3.jpg'),
                        fit: BoxFit.cover
                      )
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
              const SizedBox(height: 10,),
              // Center(
              //   child: Container(
              //     // height: 40,
              //     width: MediaQuery.sizeOf(context).width*0.9,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey[200]!),
              //       borderRadius: BorderRadius.circular(12),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.2),
              //           spreadRadius: 0.2,
              //           blurRadius: 1,
              //           offset: const Offset(0, 1),
              //         ),
              //       ],
              //     ),
              //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              //     child: const Row(
              //       children: [
              //         Icon(Icons.search),
              //         SizedBox(width: 10,),
              //         Text("Search")
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 5,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SectionHeaderViewAll(
                  text: "Friends",
                  route: AppRoutes.allFriends,
                ),
              ),
              const SizedBox(height: 10,),
              FutureBuilder<List<User>>(
                future: FriendRepository().getAllFriends(AuthService().getCurrentUser().uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No friends found.'));
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
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(MediaQuery.of(context).size.width, 50)
                  ),
                  child: Text(
                    "Create Your Own Event/List",
                    style: AppStyles.headLineStyle3.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
        ),
      ),
    );
  }
}
