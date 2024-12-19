import 'package:flutter/material.dart';

import '../models/repositories/event_repository.dart';
import '../models/user_model.dart';
import '../views/profile/friend_profile.dart';
import 'notification_circle.dart';

class FriendAvatar extends StatefulWidget {
  final User friend;
  final bool showEventsNotification;
  final bool showName;
  final double avatarSize;
  final bool showUpcomingEvents;

  const FriendAvatar({
    super.key,
    required this.friend,
    this.showEventsNotification = true,
    this.showName = true,
    this.showUpcomingEvents = true,
    this.avatarSize = 65,
  });

  @override
  State<FriendAvatar> createState() => _FriendAvatarState();
}

class _FriendAvatarState extends State<FriendAvatar> {
  // late final int _eventsNum;

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
                          builder: (context) => FriendProfile(friendData: widget.friend),
                        ),
                      );
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    icon: Container(
                      height: widget.avatarSize,
                      width: widget.avatarSize,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.avatarSize),
                        border: Border.all(color: const Color(0xFF5AAB37), width: 1.5),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: AssetImage(
                                ((widget.friend.gender) == 'm')?
                                "assets/images/male-avatar.png"
                                : "assets/images/female-avatar.png"),
                              fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                  ),
                  widget.showEventsNotification?
                  FutureBuilder(
                    future: EventRepository().getEventsCountByUserId(widget.friend.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                       return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data! == null) {
                       return const Center(child: Text('No events found.'));
                      } else {
                        final _eventsNum = snapshot.data!;
                        if (_eventsNum > 0 ) {
                          return NotificationCircle(num: _eventsNum,);
                        }
                        return SizedBox();
                   }
                 }
                ): const SizedBox(height: 0,width: 0,),
              ]
            ),
          ),
          widget.showName
              ? Text(
            widget.friend.name.split(' ')[0],
            style: const TextStyle(fontSize: 15),)
              : const SizedBox(height: 0, width: 0),
        ],
      );

  }
}
