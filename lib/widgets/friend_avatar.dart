import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/notification_circle.dart';

class FriendAvatar extends StatelessWidget {
  final Map<String, dynamic> friend;
  final bool showEventsNotification;
  final bool showName;
  final double avatarSize = 65;

  const FriendAvatar({super.key, required this.friend, this.showEventsNotification=true, this.showName=true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: const AlignmentDirectional(1.2, -1),
          children: [
            MaterialButton(
              onPressed: () {  },
              padding: EdgeInsets.zero,
              child: Container(
                height: avatarSize,
                width: avatarSize,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(avatarSize),
                  border: Border.all(color: const Color(0xFF5AAB37), width: 2),
                  // image: DecorationImage(
                  //   image: AssetImage(friend['profile_image']==""?"assets/images/male.png":friend['profile_image']),
                  //   fit: BoxFit.cover
                  // )
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage(friend['profile_image']==""?(friend['gender']=='m'?"assets/images/male-avatar.png":"assets/images/female-avatar.png"):friend['profile_image']),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            showEventsNotification && friend['upcoming_events_num'] > 0?NotificationCircle(upcomingEventsNum: friend['upcoming_events_num'],):const SizedBox(height: 0,width: 0,)
          ]
        ),
        showName?Text(friend['name'].split(' ')[0]):const SizedBox(height: 0,width: 0,)
      ],
    );
  }
}
