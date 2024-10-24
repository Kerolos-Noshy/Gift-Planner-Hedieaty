import 'package:flutter/material.dart';
import 'package:hedieaty/utils/all_json.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';

import '../res/styles/app_styles.dart';

class AllFriends extends StatelessWidget {
  const AllFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: const Text("All Friends"),
      ),
      body: ListView(
          children: [
            const SizedBox(height: 10,),
            SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: friendsList
                    .map((singleFriend) =>
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FriendAvatar(friend: singleFriend, showEventsNum: false,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5,),
                                Text(
                                  singleFriend['name'],
                                  style: AppStyles.headLineStyle3,
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                "Upcoming Events Number: ${singleFriend['upcoming_events_num']}",
                                style: AppStyles.headLineStyle4,)
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    "Unfollow",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 1,
                          width: 400,
                          color: Colors.grey[400],

                        ),
                        const SizedBox(height: 20,)
                      ],
                    )).toList(),
              ),
            ),
          ]
      ),
    );
  }
}
