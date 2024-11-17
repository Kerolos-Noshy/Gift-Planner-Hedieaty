import 'package:flutter/material.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/utils/all_json.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';

import '../../constants/styles/app_styles.dart';
import '../../models/repositories/friend_repository.dart';
import '../../models/user_model.dart';

class AllFriends extends StatelessWidget {
  const AllFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: const Text("All Friends"),
      ),
      body: FutureBuilder<List<User>>(
        future: FriendRepository().getFriends(1),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No friends found.'));
          } else {
            // Now we have the friends data from the database
            List<User> friends = snapshot.data!;
            print(friends.map((friend) => friend.name));
            return SingleChildScrollView(

                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: friends
                        .map((singleFriend) =>
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    FriendAvatar(
                                      friend: singleFriend,
                                      showEventsNotification: false,
                                      showName: false,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          singleFriend.name,
                                          style: AppStyles.headLineStyle3,
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          "Upcoming Events: 0",
                                          style: AppStyles.headLineStyle4,)
                                      ],
                                    ),
                                  ],
                                ),
                                
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(

                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4)
                                  ),
                                  child: const Text(
                                    "Unfollow",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                )

                                // Column(
                                //   children: [
                                //     Container(
                                //       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                //       decoration: BoxDecoration(
                                //         color: Colors.red,
                                //         borderRadius: BorderRadius.circular(3),
                                //       ),
                                //       child: const Text(
                                //         "Unfollow",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.w500,
                                //             color: Colors.white
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              height: 1,
                              width: 400,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 15,)
                          ],
                        )
                    ).toList(),
                  ),
                );
          }
        },
      ),






    );
  }
}
