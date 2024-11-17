import 'package:flutter/material.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';


class EventCard extends StatelessWidget {
  final String date;
  const EventCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0.2,
            blurRadius: 2,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Birthday Party"),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),

                ),
                child: Icon(Icons.cake_outlined),
              )
            ],
          ),
          Divider(),

          FutureBuilder<User?>(
            future: UserRepository().getUserById(1),
            builder: (context, snapshot){
              User friend = snapshot.data!;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: FriendAvatar(friend: friend, showEventsNotification: false, showName: false,)),
                  Expanded(child: Text(friend.name))
                ]
              );
            }
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date)
            ],
          )
        ],
      ),
    );
  }
}
