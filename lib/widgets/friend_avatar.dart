import 'package:flutter/material.dart';
import 'package:hedieaty/widgets/notification_circle.dart';

class FriendAvatar extends StatelessWidget {
  final Map<String, dynamic> friend;
  final bool showEventsNotification;
  final bool showName;

  const FriendAvatar({super.key, required this.friend, this.showEventsNotification=true, this.showName=true});

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
              showEventsNotification?const NotificationCircle():const SizedBox(height: 0,width: 0,)
            ]
          ),
          showName?Text(friend['name'].split(' ')[0]):const SizedBox(height: 0,width: 0,)
        ],
      ),
    );
  }
}
