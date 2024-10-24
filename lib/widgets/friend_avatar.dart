import 'package:flutter/material.dart';
import 'package:hedieaty/views/res/styles/app_styles.dart';
import 'package:hedieaty/widgets/notification_circle.dart';

class FriendAvatar extends StatelessWidget {
  final Map<String, dynamic> friend;
  final bool showEventsNum;

  const FriendAvatar({super.key, required this.friend, this.showEventsNum=true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Stack(
            alignment: const AlignmentDirectional(1.2, -1),
            children: [
              Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(color: Colors.black, width: 1),
                  // image: DecorationImage(
                  //   image: AssetImage(friend['profile_image']==""?"assets/images/male.png":friend['profile_image']),
                  //   fit: BoxFit.cover
                  // )
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                          image: AssetImage(friend['profile_image']==""?"assets/images/user.png":friend['profile_image']),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
              NotificationCircle(upcomingEventsNum: showEventsNum?friend['upcoming_events_num']:0)
            ]
          ),
          const SizedBox(height: 5,),
          Text(showEventsNum?friend['name'].split(' ')[0]:"", style: AppStyles.headLineStyle4,)
        ],
      ),
    );
  }
}
