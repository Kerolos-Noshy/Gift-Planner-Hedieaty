import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../views/profile/friend_profile.dart';

class FriendAvatar extends StatelessWidget {
  final User friend;
  final bool showEventsNotification;
  final bool showName;
  final double avatarSize;

  const FriendAvatar({
    super.key,
    required this.friend,
    this.showEventsNotification = true,
    this.showName = true,
    this.avatarSize = 65,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 7),
          child: Stack(
            alignment: const AlignmentDirectional(1.4, -1.2),
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfile(friendData: friend),
                    ),
                  );
                },
                padding: const EdgeInsets.symmetric(horizontal: 0),
                icon: Container(
                  height: avatarSize,
                  width: avatarSize,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(avatarSize),
                    border: Border.all(color: const Color(0xFF5AAB37), width: 1.5),
                    // image: DecorationImage(
                    //   image: AssetImage(friend['profile_image']==""?"assets/images/male.png":friend['profile_image']),
                    //   fit: BoxFit.cover
                    // )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: AssetImage(
                              ((friend.gender) == 'm')?
                                  "assets/images/male-avatar.png"
                                  : "assets/images/female-avatar.png"),
                              fit: BoxFit.cover

                        )
                    ),
                  ),
                ),
              ),
              // TODO: get the number of upcoming events from db
              // showEventsNotification && friend['upcoming_events_num'] > 0?NotificationCircle(num: friend['upcoming_events_num'],):const SizedBox(height: 0,width: 0,)
            ]
          ),
        ),
        showName
            ? Text((friend.name.split(' ')[0]))
            : const SizedBox(height: 0, width: 0),
      ],
    );
  }
}
