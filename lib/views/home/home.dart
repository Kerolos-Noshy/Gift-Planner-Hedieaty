import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';

import '../../routes/app_routes.dart';
import '../../utils/all_json.dart';
import '../../widgets/app_double_text.dart';
import '../res/styles/app_styles.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
              child: Text(
                "Hello There",
                style: AppStyles.headLineStyle2,
              ),
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: AppDoubleText(
                bigText: "Friends",
                smallText: "View all",
                route: AppRoutes.allFriends,
              ),
            ),
            const SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children:
                    friendsList.take(6).map((singleFriend) => FriendAvatar(friend: singleFriend)).toList(),
                ),
              )
            )
          ],
      ),
    );
  }
}
